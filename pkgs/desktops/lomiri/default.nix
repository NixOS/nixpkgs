{
  lib,
  pkgs,
  libsForQt5,
}:

let
  packages =
    self:
    let
      inherit (self) callPackage;
    in
    {
      #### Core Apps
      lomiri = callPackage ./applications/lomiri { };
      lomiri-calculator-app = callPackage ./applications/lomiri-calculator-app { };
      lomiri-camera-app = callPackage ./applications/lomiri-camera-app { };
      lomiri-clock-app = callPackage ./applications/lomiri-clock-app { };
      lomiri-filemanager-app = callPackage ./applications/lomiri-filemanager-app { };
      lomiri-gallery-app = callPackage ./applications/lomiri-gallery-app { };
      lomiri-system-settings-unwrapped = callPackage ./applications/lomiri-system-settings { };
      lomiri-system-settings-security-privacy =
        callPackage
          ./applications/lomiri-system-settings/plugins/lomiri-system-settings-security-privacy.nix
          { };
      lomiri-system-settings = callPackage ./applications/lomiri-system-settings/wrapper.nix { };
      lomiri-terminal-app = callPackage ./applications/lomiri-terminal-app { };
      morph-browser = callPackage ./applications/morph-browser { };
      teleports = callPackage ./applications/teleports { };

      #### Data
      lomiri-schemas = callPackage ./data/lomiri-schemas { };
      lomiri-session = callPackage ./data/lomiri-session { };
      lomiri-sounds = callPackage ./data/lomiri-sounds { };
      lomiri-wallpapers = callPackage ./data/lomiri-wallpapers { };
      suru-icon-theme = callPackage ./data/suru-icon-theme { };

      #### Development tools / libraries
      cmake-extras = callPackage ./development/cmake-extras { };
      deviceinfo = callPackage ./development/deviceinfo { };
      geonames = callPackage ./development/geonames { };
      gmenuharness = callPackage ./development/gmenuharness { };
      libusermetrics = callPackage ./development/libusermetrics { };
      lomiri-api = callPackage ./development/lomiri-api { };
      lomiri-app-launch = callPackage ./development/lomiri-app-launch { };
      qtmir = callPackage ./development/qtmir { };
      trust-store = callPackage ./development/trust-store { };
      u1db-qt = callPackage ./development/u1db-qt { };

      #### QML / QML-related
      lomiri-action-api = callPackage ./qml/lomiri-action-api { };
      lomiri-notifications = callPackage ./qml/lomiri-notifications { };
      lomiri-push-qml = callPackage ./qml/lomiri-push-qml { };
      lomiri-settings-components = callPackage ./qml/lomiri-settings-components { };
      lomiri-ui-extras = callPackage ./qml/lomiri-ui-extras { };
      lomiri-ui-toolkit = callPackage ./qml/lomiri-ui-toolkit { };
      qqc2-suru-style = callPackage ./qml/qqc2-suru-style { };

      #### Services
      biometryd = callPackage ./services/biometryd { };
      content-hub = callPackage ./services/content-hub { };
      hfd-service = callPackage ./services/hfd-service { };
      history-service = callPackage ./services/history-service { };
      lomiri-download-manager = callPackage ./services/lomiri-download-manager { };
      lomiri-indicator-network = callPackage ./services/lomiri-indicator-network { };
      lomiri-polkit-agent = callPackage ./services/lomiri-polkit-agent { };
      lomiri-thumbnailer = callPackage ./services/lomiri-thumbnailer { };
      lomiri-url-dispatcher = callPackage ./services/lomiri-url-dispatcher { };
      mediascanner2 = callPackage ./services/mediascanner2 { };
      telephony-service = callPackage ./services/telephony-service { };
    };
in
lib.makeScope libsForQt5.newScope packages
