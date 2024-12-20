{
  lib,
  config,
  pkgs,
}:
let
  packages =
    self:
    let
      inherit (self) callPackage;
    in
    {
      #### LIBRARIES
      dtkcommon = callPackage ./library/dtkcommon { };
      dtkcore = callPackage ./library/dtkcore { };
      dtkgui = callPackage ./library/dtkgui { };
      dtkwidget = callPackage ./library/dtkwidget { };
      dtkdeclarative = callPackage ./library/dtkdeclarative { };
      dtklog = callPackage ./library/dtklog { };
      deepin-pdfium = callPackage ./library/deepin-pdfium { };
      qt5platform-plugins = callPackage ./library/qt5platform-plugins { };
      qt5integration = callPackage ./library/qt5integration { };
      deepin-wayland-protocols = callPackage ./library/deepin-wayland-protocols { };
      deepin-ocr-plugin-manager = callPackage ./library/deepin-ocr-plugin-manager { };
      dwayland = callPackage ./library/dwayland { };
      dde-qt-dbus-factory = callPackage ./library/dde-qt-dbus-factory { };
      disomaster = callPackage ./library/disomaster { };
      docparser = callPackage ./library/docparser { };
      gio-qt = callPackage ./library/gio-qt { };
      image-editor = callPackage ./library/image-editor { };
      udisks2-qt5 = callPackage ./library/udisks2-qt5 { };
      util-dfm = callPackage ./library/util-dfm { };
      dtk6core = callPackage ./library/dtk6core { };
      dtk6gui = callPackage ./library/dtk6gui { };
      dtk6widget = callPackage ./library/dtk6widget { };
      dtk6declarative = callPackage ./library/dtk6declarative { };
      dtk6systemsettings = callPackage ./library/dtk6systemsettings { };
      dtk6log = callPackage ./library/dtk6log { };
      qt6platform-plugins = callPackage ./library/qt6platform-plugins { };
      qt6integration = callPackage ./library/qt6integration { };
      qt6mpris = callPackage ./library/qt6mpris { };
      treeland-protocols = callPackage ./library/treeland-protocols { };

      #### CORE
      deepin-kwin = callPackage ./core/deepin-kwin { };
      dde-appearance = callPackage ./core/dde-appearance { };
      dde-app-services = callPackage ./core/dde-app-services { };
      dde-application-manager = callPackage ./core/dde-application-manager { };
      dde-control-center = callPackage ./core/dde-control-center { };
      dde-calendar = callPackage ./core/dde-calendar { };
      dde-clipboard = callPackage ./core/dde-clipboard { };
      dde-file-manager = callPackage ./core/dde-file-manager { };
      dde-launchpad = callPackage ./core/dde-launchpad { };
      dde-network-core = callPackage ./core/dde-network-core { };
      dde-session = callPackage ./core/dde-session { };
      dde-session-shell = callPackage ./core/dde-session-shell { };
      dde-session-ui = callPackage ./core/dde-session-ui { };
      deepin-service-manager = callPackage ./core/deepin-service-manager { };
      dde-polkit-agent = callPackage ./core/dde-polkit-agent { };
      dpa-ext-gnomekeyring = callPackage ./core/dpa-ext-gnomekeyring { };
      dde-gsettings-schemas = callPackage ./core/dde-gsettings-schemas { };
      dde-widgets = callPackage ./core/dde-widgets { };
      dde-shell = callPackage ./core/dde-shell { };
      dde-grand-search = callPackage ./core/dde-grand-search { };
      dde-tray-loader = callPackage ./core/dde-tray-loader { };
      dde-api-proxy = callPackage ./core/dde-api-proxy { };

      #### Dtk Application
      deepin-album = callPackage ./apps/deepin-album { };
      deepin-calculator = callPackage ./apps/deepin-calculator { };
      deepin-camera = callPackage ./apps/deepin-camera { };
      deepin-compressor = callPackage ./apps/deepin-compressor { };
      deepin-draw = callPackage ./apps/deepin-draw { };
      deepin-editor = callPackage ./apps/deepin-editor { };
      deepin-image-viewer = callPackage ./apps/deepin-image-viewer { };
      deepin-movie-reborn = callPackage ./apps/deepin-movie-reborn { };
      deepin-music = callPackage ./apps/deepin-music { };
      deepin-picker = callPackage ./apps/deepin-picker { };
      deepin-screen-recorder = callPackage ./apps/deepin-screen-recorder { };
      deepin-shortcut-viewer = callPackage ./apps/deepin-shortcut-viewer { };
      deepin-system-monitor = callPackage ./apps/deepin-system-monitor { };
      deepin-terminal = callPackage ./apps/deepin-terminal { };
      deepin-reader = callPackage ./apps/deepin-reader { };
      deepin-voice-note = callPackage ./apps/deepin-voice-note { };
      deepin-screensaver = callPackage ./apps/deepin-screensaver { };

      #### Go Packages
      dde-api = callPackage ./go-package/dde-api { };
      dde-daemon = callPackage ./go-package/dde-daemon { };
      deepin-pw-check = callPackage ./go-package/deepin-pw-check { };
      deepin-desktop-schemas = callPackage ./go-package/deepin-desktop-schemas { };
      startdde = callPackage ./go-package/startdde { };

      #### TOOLS
      dde-device-formatter = callPackage ./tools/dde-device-formatter { };
      deepin-gettext-tools = callPackage ./tools/deepin-gettext-tools { };
      deepin-anything = callPackage ./tools/deepin-anything { };

      #### ARTWORK
      dde-account-faces = callPackage ./artwork/dde-account-faces { };
      deepin-icon-theme = callPackage ./artwork/deepin-icon-theme { };
      deepin-wallpapers = callPackage ./artwork/deepin-wallpapers { };
      deepin-gtk-theme = callPackage ./artwork/deepin-gtk-theme { };
      deepin-sound-theme = callPackage ./artwork/deepin-sound-theme { };
      deepin-desktop-theme = callPackage ./artwork/deepin-desktop-theme { };

      #### MISC
      deepin-desktop-base = callPackage ./misc/deepin-desktop-base { };
    }
    // lib.optionalAttrs config.allowAliases {
      dde-kwin = throw "The 'deepin.dde-kwin' package was removed as it is outdated and no longer relevant."; # added 2023-09-27
      dde-launcher = throw "The 'deepin.dde-launcher' is no longer maintained. Please use 'deepin.dde-launchpad' instead."; # added 2023-11-23
      dde-dock = throw "The 'deepin.dde-dock' is no longer maintained. Please use 'deepin.dde-tray-loader' instead."; # added 2024-08-28
      deepin-clone = throw "The 'deepin.deepin-clone' package was removed as it is broken and unmaintained."; # added 2024-08-23
      deepin-turbo = throw "The 'deepin.deepin-turbo' package was removed as it is outdated and no longer relevant."; # added 2024-12-06
      go-lib = throw "Then 'deepin.go-lib' package was removed, use 'go mod' to manage it"; # added 2024-05-31
      go-gir-generator = throw "Then 'deepin.go-gir-generator' package was removed, use 'go mod' to manage it"; # added 2024-05-31
      go-dbus-factory = throw "Then 'deepin.go-dbus-factory' package was removed, use 'go mod' to manage it"; # added 2024-05-31
    };
in
lib.makeScope pkgs.newScope packages
