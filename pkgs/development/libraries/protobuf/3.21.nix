{ callPackage, abseil-cpp, ... }:

callPackage ./generic-v3-cmake.nix {
  version = "3.21.12";
  sha256 = "sha256-VZQEFHq17UsTH5CZZOcJBKiScGV2xPJ/e6gkkVliRCU=";
}
