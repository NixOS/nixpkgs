{ callPackage, ... } @ args:

callPackage ./generic-v3.nix ({
  version = "3.8.0";
  sha256 = "0vll02a6k46k720wfh25sl4hdai0130s3ix2l1wh6j1lm9pi7bm8";
} // args)
