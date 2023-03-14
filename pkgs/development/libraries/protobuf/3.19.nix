{ callPackage, ... } @ args:

callPackage ./generic-v3.nix ({
  version = "3.19.6";
  sha256 = "sha256-+ul9F8tyrwk2p25Dd9ragqwpYzdxdeGjpXhLAwKYWfM=";
} // args)
