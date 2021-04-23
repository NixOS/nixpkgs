{ callPackage, indilib, indi-3rdparty }:

let
  indi-with-drivers = ./indi-with-drivers.nix;
in
callPackage indi-with-drivers {
  pkgName = "indi-full";
  extraDrivers = [
    indi-3rdparty
  ];
}
