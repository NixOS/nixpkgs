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
    suru-icon-theme = callPackage ./data/suru-icon-theme { };

    #### Development tools / libraries
    cmake-extras = callPackage ./development/cmake-extras { };
    deviceinfo = callPackage ./development/deviceinfo { };
    geonames = callPackage ./development/geonames { };
    gmenuharness = callPackage ./development/gmenuharness { };
    libusermetrics = callPackage ./development/libusermetrics { };
    lomiri-api = callPackage ./development/lomiri-api { };
    trust-store = callPackage ./development/trust-store { };
    u1db-qt = callPackage ./development/u1db-qt { };

    #### QML / QML-related
    lomiri-action-api = callPackage ./qml/lomiri-action-api { };
    lomiri-notifications = callPackage ./qml/lomiri-notifications { };
    lomiri-settings-components = callPackage ./qml/lomiri-settings-components { };
    lomiri-ui-toolkit = callPackage ./qml/lomiri-ui-toolkit { };

    #### Services
    biometryd = callPackage ./services/biometryd { };
    hfd-service = callPackage ./services/hfd-service { };
    lomiri-app-launch = callPackage ./development/lomiri-app-launch { };
    mediascanner2 = callPackage ./services/mediascanner2 { };
  };
in
  lib.makeScope libsForQt5.newScope packages
