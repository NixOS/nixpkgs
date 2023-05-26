{ callPackage, ... }@args:

callPackage ./generic.nix (rec {
  version = "4.4.4";
  branch = version;
  sha256 = "sha256-R7H79wosCQ2cD65ZENoRxkBsqSQIu2nYyTXNRsYix84=";

} // args)
