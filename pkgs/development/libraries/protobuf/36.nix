{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "36.1";
    hash = "sha256-SB17YwMdkCp4jPcX5Csf13IUGVNLaqwH5YJXugAeqMY=";
  }
  // args
)
