// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Blockchain for Transparent Charity Donation
 * @dev A transparent and trustless donation management system using Ethereum blockchain.
 */
contract Project {
    address public owner;
    uint256 public totalDonations;

    struct Donor {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Donor) public donors;

    event DonationReceived(address indexed donor, uint256 amount, uint256 timestamp);
    event FundsWithdrawn(address indexed owner, uint256 amount, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Allows anyone to donate ETH to the charity.
     */
    function donate() external payable {
        require(msg.value > 0, "Donation must be greater than zero");

        donors[msg.sender].amount += msg.value;
        donors[msg.sender].timestamp = block.timestamp;
        totalDonations += msg.value;

        emit DonationReceived(msg.sender, msg.value, block.timestamp);
    }

    /**
     * @dev Allows the owner to withdraw collected funds for charitable use.
     * @param _amount Amount to withdraw in wei.
     */
    function withdrawFunds(uint256 _amount) external onlyOwner {
        require(_amount <= address(this).balance, "Insufficient contract balance");

        payable(owner).transfer(_amount);
        emit FundsWithdrawn(owner, _amount, block.timestamp);
    }

    /**
     * @dev Returns contract balance for transparency.
     */
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
