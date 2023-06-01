{ lib, pkgs, libsForQt5 }:
let
  packages = self:
  let
    inherit (self) callPackage;
  in {
    #### LIBRARIES
    dtkcommon = callPackage ./library/dtkcommon { };
    dtkcore = callPackage ./library/dtkcore { };
    dtkgui = callPackage ./library/dtkgui { };
    dtkwidget = callPackage ./library/dtkwidget { };
    deepin-pdfium = callPackage ./library/deepin-pdfium { };
    qt5platform-plugins = callPackage ./library/qt5platform-plugins { };
    qt5integration = callPackage ./library/qt5integration { };
    deepin-wayland-protocols = callPackage ./library/deepin-wayland-protocols { };
    dwayland = callPackage ./library/dwayland { };
    dde-qt-dbus-factory = callPackage ./library/dde-qt-dbus-factory { };
    disomaster = callPackage ./library/disomaster { };
    docparser = callPackage ./library/docparser { };
    gio-qt = callPackage ./library/gio-qt { };
    image-editor = callPackage ./library/image-editor { };
    udisks2-qt5 = callPackage ./library/udisks2-qt5 { };
    util-dfm = callPackage ./library/util-dfm { };

    #### CORE
    dde-kwin = callPackage ./core/dde-kwin { };
    deepin-kwin = callPackage ./core/deepin-kwin { };
    dde-app-services = callPackage ./core/dde-app-services { };
    dde-control-center = callPackage ./core/dde-control-center { };
    dde-calendar = callPackage ./core/dde-calendar { };
    dde-clipboard = callPackage ./core/dde-clipboard { };
    dde-dock = callPackage ./core/dde-dock { };
    dde-file-manager = callPackage ./core/dde-file-manager { };
    dde-launcher = callPackage ./core/dde-launcher { };
    dde-network-core = callPackage ./core/dde-network-core { };
    dde-session-shell = callPackage ./core/dde-session-shell { };
    dde-session-ui = callPackage ./core/dde-session-ui { };
    dde-polkit-agent = callPackage ./core/dde-polkit-agent { };
    dpa-ext-gnomekeyring = callPackage ./core/dpa-ext-gnomekeyring { };
    dde-gsettings-schemas = callPackage ./core/dde-gsettings-schemas { };

    #### Dtk Application
    deepin-album = callPackage ./apps/deepin-album { };
    deepin-calculator = callPackage ./apps/deepin-calculator { };
    deepin-camera = callPackage ./apps/deepin-camera { };
    deepin-compressor = callPackage ./apps/deepin-compressor { };
    deepin-clone = callPackage ./apps/deepin-clone { };
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
    go-lib = callPackage ./go-package/go-lib { };
    go-gir-generator = callPackage ./go-package/go-gir-generator { };
    go-dbus-factory = callPackage ./go-package/go-dbus-factory { };
    dde-api = callPackage ./go-package/dde-api { };
    dde-daemon = callPackage ./go-package/dde-daemon { };
    deepin-pw-check = callPackage ./go-package/deepin-pw-check { };
    deepin-desktop-schemas = callPackage ./go-package/deepin-desktop-schemas { };
    startdde = callPackage ./go-package/startdde { };

    #### TOOLS
    dde-device-formatter = callPackage ./tools/dde-device-formatter { };
    deepin-gettext-tools = callPackage ./tools/deepin-gettext-tools { };

    #### ARTWORK
    dde-account-faces = callPackage ./artwork/dde-account-faces { };
    deepin-icon-theme = callPackage ./artwork/deepin-icon-theme { };
    deepin-wallpapers = callPackage ./artwork/deepin-wallpapers { };
    deepin-gtk-theme = callPackage ./artwork/deepin-gtk-theme { };
    deepin-sound-theme = callPackage ./artwork/deepin-sound-theme { };

    #### MISC
    deepin-desktop-base = callPackage ./misc/deepin-desktop-base { };
    deepin-turbo = callPackage ./misc/deepin-turbo { };
  };
in
lib.makeScope libsForQt5.newScope packages
