{ lib
, pkgs
, libsForQt5
}:

let
  packages = self: let
    inherit (self) callPackage;
  in {
    #### Development tools / libraries
    cmake-extras = callPackage ./development/cmake-extras { };
    deviceinfo = callPackage ./development/deviceinfo { };
    gmenuharness = callPackage ./development/gmenuharness { };
    lomiri-api = callPackage ./development/lomiri-api { };
  };
in
  lib.makeScope libsForQt5.newScope packages
