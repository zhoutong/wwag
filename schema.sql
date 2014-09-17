# Deleting all tables in reverse order

DROP TABLE IF EXISTS `VenueEquipment`;
DROP TABLE IF EXISTS `Equipment`;
DROP TABLE IF EXISTS `Venue`;
DROP TABLE IF EXISTS `GameShipmentDetail`;
DROP TABLE IF EXISTS `GameShipment`;
DROP TABLE IF EXISTS `OrderDetail`;
DROP TABLE IF EXISTS `GameDistributorOrder`;
DROP TABLE IF EXISTS `GameDistributorAddress`;
DROP TABLE IF EXISTS `GameDistributor`;
DROP TABLE IF EXISTS `ViewerOrderLine`;
DROP TABLE IF EXISTS `Video`;
DROP TABLE IF EXISTS `Game`;
DROP TABLE IF EXISTS `Achievement`;
DROP TABLE IF EXISTS `InstanceRunPlayer`;
DROP TABLE IF EXISTS `InstanceRun`;
DROP TABLE IF EXISTS `ViewerOrder`;
DROP TABLE IF EXISTS `ViewerAddress`;
DROP TABLE IF EXISTS `PremiumViewer`;
DROP TABLE IF EXISTS `CrowdFundingViewer`;
DROP TABLE IF EXISTS `Viewer`;
DROP TABLE IF EXISTS `PlayerAddress`;
DROP TABLE IF EXISTS `Address`;
DROP TABLE IF EXISTS `Player`;

CREATE TABLE `Player` (
  `PlayerID` SMALLINT NOT NULL AUTO_INCREMENT,
  `SupervisorID` SMALLINT NOT NULL,
  `FirstName` VARCHAR(50) NOT NULL,
  `LastName` VARCHAR(50) NOT NULL,
  `Role` VARCHAR(50) NOT NULL,
  `Type` VARCHAR(1) NOT NULL,
  `ProfileDescription` TEXT,
  `Email` VARCHAR(50) NOT NULL,
  `GameHandle` VARCHAR(50) NOT NULL,
  `Phone` VARCHAR(14),
  `VoiP` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`PlayerID`, `SupervisorID`),
  FOREIGN KEY (`SupervisorID`) REFERENCES `Player` (`PlayerID`)
) ENGINE=InnoDB;

CREATE TABLE `Address` (
  `AddressID` SMALLINT NOT NULL AUTO_INCREMENT,
  `StreetNumber` SMALLINT NOT NULL,
  `StreetNumberSuffix` VARCHAR(20),
  `StreetName` VARCHAR(50),
  `StreetType` VARCHAR(20) NOT NULL,
  `AddressType` VARCHAR(20),
  `AddressTypeIdentifier` VARCHAR(20),
  `MinorMunicipality` VARCHAR(50),
  `MajorMunicipality` VARCHAR(50) NOT NULL,
  `GoverningDistrict` VARCHAR(50) NOT NULL,
  `PostalArea` VARCHAR(4) NOT NULL,
  `Country` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`AddressID`)
) ENGINE=InnoDB;

CREATE TABLE `PlayerAddress` (
  `PlayerID` SMALLINT NOT NULL,
  `AddressID` SMALLINT NOT NULL,
  `StartDate` DATE NOT NULL,
  `EndDate` DATE,
  PRIMARY KEY (`PlayerID`, `AddressID`, `StartDate`),
  FOREIGN KEY (`PlayerID`) REFERENCES `Player` (`PlayerID`),
  FOREIGN KEY (`AddressID`) REFERENCES `Address` (`AddressID`)
) ENGINE=InnoDB;

CREATE TABLE `Viewer` (
  `ViewerID` SMALLINT NOT NULL AUTO_INCREMENT,
  `ViewerType` CHAR(1) NOT NULL,
  `DateOfBirth` DATE,
  `Email` VARCHAR(50),
  PRIMARY KEY (`ViewerID`)
) ENGINE=InnoDB;

CREATE TABLE `CrowdFundingViewer` (
  `ViewerID` SMALLINT NOT NULL,
  `FirstName` VARCHAR(45),
  `LastName` VARCHAR(45),
  `TotalAmountDonated` DECIMAL(8,2),
  PRIMARY KEY (`ViewerID`),
  FOREIGN KEY (`ViewerID`) REFERENCES `Viewer` (`ViewerID`)
) ENGINE=InnoDB;

CREATE TABLE `PremiumViewer` (
  `ViewerID` SMALLINT NOT NULL,
  `RenewalDate` DATE NOT NULL,
  PRIMARY KEY (`ViewerID`),
  FOREIGN KEY (`ViewerID`) REFERENCES `Viewer` (`ViewerID`)
) ENGINE=InnoDB;

CREATE TABLE `ViewerAddress` (
  `ViewerID` SMALLINT NOT NULL,
  `AddressID` SMALLINT NOT NULL,
  `StartDate` DATE NOT NULL,
  `EndDate` DATE,
  PRIMARY KEY (`ViewerID`, `AddressID`, `StartDate`),
  FOREIGN KEY (`ViewerID`) REFERENCES `Viewer` (`ViewerID`),
  FOREIGN KEY (`AddressID`) REFERENCES `Address` (`AddressID`)
) ENGINE=InnoDB;

CREATE TABLE `ViewerOrder` (
  `ViewerOrderID` SMALLINT NOT NULL AUTO_INCREMENT,
  `OrderDate` DATE NOT NULL,
  `ViewedStatus` CHAR(7) NOT NULL,
  `ViewerID` SMALLINT NOT NULL,
  PRIMARY KEY (`ViewerOrderID`),
  FOREIGN KEY (`ViewerID`) REFERENCES `Viewer` (`ViewerID`)
) ENGINE=InnoDB;

CREATE TABLE `InstanceRun` (
  `InstanceRunID` SMALLINT NOT NULL AUTO_INCREMENT,
  `SupervisorID` SMALLINT NOT NULL,
  `Name` VARCHAR(45),
  `RecordedTime` DATETIME,
  `CategoryName` VARCHAR(50),
  PRIMARY KEY (`InstanceRunID`),
  FOREIGN KEY (`SupervisorID`) REFERENCES `Player` (`PlayerID`)
) ENGINE=InnoDB;

CREATE TABLE `InstanceRunPlayer` (
  `PlayerID` SMALLINT NOT NULL,
  `InstanceRunID` SMALLINT NOT NULL,
  `PerformanceNotes` TEXT,
  PRIMARY KEY (`PlayerID`, `InstanceRunID`),
  FOREIGN KEY (`PlayerID`) REFERENCES `Player` (`PlayerID`),
  FOREIGN KEY (`InstanceRunID`) REFERENCES `InstanceRun` (`InstanceRunID`)
) ENGINE=InnoDB;

CREATE TABLE `Achievement` (
  `AchievementID` SMALLINT NOT NULL AUTO_INCREMENT,
  `InstanceRunID` SMALLINT NOT NULL,
  `WhenAchieved` DATETIME,
  `Name` VARCHAR(45),
  `RewardBody` VARCHAR(45),
  PRIMARY KEY (`AchievementID`, `InstanceRunID`),
  FOREIGN KEY (`InstanceRunID`) REFERENCES `InstanceRun` (`InstanceRunID`)
) ENGINE=InnoDB;

CREATE TABLE `Game` (
  `GameID` SMALLINT NOT NULL AUTO_INCREMENT,
  `Genre` VARCHAR(50),
  `Review` TEXT,
  `StarRating` SMALLINT,
  `ClassificationRating` VARCHAR(5),
  `PlatformNotes` TEXT,
  `PromotionLink` VARCHAR(50),
  `Cost` DECIMAL(5,2),
  PRIMARY KEY (`GameID`)
) ENGINE=InnoDB;

CREATE TABLE `Video` (
  `VideoID` SMALLINT NOT NULL AUTO_INCREMENT,
  `URL` VARCHAR(50) NOT NULL,
  `Price` DECIMAL(5,2),
  `VideoType` VARCHAR(45),
  `InstanceRunID` SMALLINT NOT NULL,
  `GameID` SMALLINT NOT NULL,
  PRIMARY KEY (`VideoID`),
  FOREIGN KEY (`InstanceRunID`) REFERENCES `InstanceRun` (`InstanceRunID`),
  FOREIGN KEY (`GameID`) REFERENCES `Game` (`GameID`)
) ENGINE=InnoDB;

CREATE TABLE `ViewerOrderLine` (
  `VideoID` SMALLINT NOT NULL,
  `ViewerOrderID` SMALLINT NOT NULL,
  `FlagPerk` BOOLEAN NOT NULL,
  PRIMARY KEY (`VideoID`, `ViewerOrderID`),
  FOREIGN KEY (`VideoID`) REFERENCES `Video` (`VideoID`),
  FOREIGN KEY (`ViewerOrderID`) REFERENCES `ViewerOrder` (`ViewerOrderID`)
) ENGINE=InnoDB;

CREATE TABLE `GameDistributor` (
  `GameDistributorID` SMALLINT NOT NULL AUTO_INCREMENT,
  `CompanyName` VARCHAR(100) NOT NULL,
  `ContactFirstName` VARCHAR(50) NOT NULL,
  `ContactLastName` VARCHAR(50),
  `Phone` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`GameDistributorID`)
) ENGINE=InnoDB;

CREATE TABLE `GameDistributorAddress` (
  `AddressID` SMALLINT NOT NULL,
  `GameDistributorID` SMALLINT NOT NULL,
  `StartDate` DATE NOT NULL,
  `EndDate` DATE,
  PRIMARY KEY (`AddressID`, `GameDistributorID`, `StartDate`),
  FOREIGN KEY (`AddressID`) REFERENCES `Address` (`AddressID`),
  FOREIGN KEY (`GameDistributorID`) REFERENCES `GameDistributor` (`GameDistributorID`)
) ENGINE=InnoDB;

CREATE TABLE `GameDistributorOrder` (
  `GameDistributorOrderID` SMALLINT NOT NULL AUTO_INCREMENT,
  `SupplyDate` DATE NOT NULL,
  `GameDistributorID` SMALLINT NOT NULL,
  PRIMARY KEY (`GameDistributorOrderID`),
  FOREIGN KEY (`GameDistributorID`) REFERENCES `GameDistributor` (`GameDistributorID`)
) ENGINE=InnoDB;

CREATE TABLE `OrderDetail` (
  `GameDistributorOrderID` SMALLINT NOT NULL,
  `GameID` SMALLINT NOT NULL,
  `QuantityOrdered` INT NOT NULL,
  `ActualUnitPrice` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`GameDistributorOrderID`, `GameID`),
  FOREIGN KEY (`GameDistributorOrderID`) REFERENCES `GameDistributorOrder` (`GameDistributorOrderID`),
  FOREIGN KEY (`GameID`) REFERENCES `Game` (`GameID`)
) ENGINE=InnoDB;

CREATE TABLE `GameShipment` (
  `GameShipmentID` SMALLINT NOT NULL AUTO_INCREMENT,
  `DateReceived` DATE,
  `GameDistributorOrderID` SMALLINT NOT NULL,
  PRIMARY KEY (`GameShipmentID`),
  FOREIGN KEY (`GameDistributorOrderID`) REFERENCES `GameDistributor` (`GameDistributorID`)
) ENGINE=InnoDB;

CREATE TABLE `GameShipmentDetail` (
  `GameID` SMALLINT NOT NULL,
  `GameShipmentID` SMALLINT NOT NULL,
  `QuantityReceived` INT,
  PRIMARY KEY (`GameID`, `GameShipmentID`),
  FOREIGN KEY (`GameID`) REFERENCES `Game` (`GameID`),
  FOREIGN KEY (`GameShipmentID`) REFERENCES `GameShipment` (`GameShipmentID`)
) ENGINE=InnoDB;

CREATE TABLE `Venue` (
  `VenueID` SMALLINT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(50) NOT NULL,
  `VenueDescription` TEXT,
  `PowerOutlets` SMALLINT,
  `LightingNotes` TEXT,
  `SupervisorID` SMALLINT NOT NULL,
  PRIMARY KEY (`VenueID`),
  FOREIGN KEY (`SupervisorID`) REFERENCES `Player` (`PlayerID`)
) ENGINE=InnoDB;

CREATE TABLE `Equipment` (
  `EquipmentID` SMALLINT NOT NULL AUTO_INCREMENT,
  `ModelAndMake` VARCHAR(45),
  `EquipmentReview` TEXT,
  `ProcessorSpeed` VARCHAR(45),
  PRIMARY KEY (`EquipmentID`)
) ENGINE=InnoDB;

CREATE TABLE `VenueEquipment` (
  `VenueID` SMALLINT NOT NULL,
  `EquipmentID` SMALLINT NOT NULL,
  `FinancialYearStartingDate` DATE NOT NULL,
  `SoftwareVersion` VARCHAR(45),
  PRIMARY KEY (`VenueID`, `EquipmentID`),
  FOREIGN KEY (`VenueID`) REFERENCES `Venue` (`VenueID`),
  FOREIGN KEY (`EquipmentID`) REFERENCES `Equipment` (`EquipmentID`)
) ENGINE=InnoDB;
