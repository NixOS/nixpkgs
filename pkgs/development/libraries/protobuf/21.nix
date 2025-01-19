{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "21.12";
    hash = "sha256-VZQEFHq17UsTH5CZZOcJBKiScGV2xPJ/e6gkkVliRCU=";
  }
  // args
)
