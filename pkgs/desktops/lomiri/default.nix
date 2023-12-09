{ lib
, pkgs
, libsForQt5
}:

let
  packages = self: let
    inherit (self) callPackage;
  in {
    #### Data
    lomiri-schemas = callPackage ./data/lomiri-schemas { };

    #### Development tools / libraries
    cmake-extras = callPackage ./development/cmake-extras { };
    deviceinfo = callPackage ./development/deviceinfo { };
    geonames = callPackage ./development/geonames { };
    gmenuharness = callPackage ./development/gmenuharness { };
    libusermetrics = callPackage ./development/libusermetrics { };
    lomiri-api = callPackage ./development/lomiri-api { };
    u1db-qt = callPackage ./development/u1db-qt { };

    #### QML / QML-related
    lomiri-settings-components = callPackage ./qml/lomiri-settings-components { };

    #### Services
    biometryd = callPackage ./services/biometryd { };
    hfd-service = callPackage ./services/hfd-service { };
    lomiri-app-launch = callPackage ./development/lomiri-app-launch { };
  };
in
  lib.makeScope libsForQt5.newScope packages
