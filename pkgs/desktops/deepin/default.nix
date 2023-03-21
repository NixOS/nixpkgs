{ lib, pkgs, libsForQt5 }:
let
  packages = self:
  let
    inherit (self) callPackage;

    replaceAll = x: y: ''
      echo Replacing "${x}" to "${y}":
      for file in $(grep -rl "${x}"); do
        echo -- $file
        substituteInPlace $file \
          --replace "${x}" "${y}"
      done
    '';
  in {
    #### LIBRARIES
    dtkcommon = callPackage ./library/dtkcommon { };
    dtkcore = callPackage ./library/dtkcore { };
    dtkgui = callPackage ./library/dtkgui { };
    dtkwidget = callPackage ./library/dtkwidget { };
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

    #### CORE
    dde-calendar = callPackage ./core/dde-calendar { };
    dde-polkit-agent = callPackage ./core/dde-polkit-agent { };
    dpa-ext-gnomekeyring = callPackage ./core/dpa-ext-gnomekeyring { };

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
    deepin-shortcut-viewer = callPackage ./apps/deepin-shortcut-viewer { };
    deepin-terminal = callPackage ./apps/deepin-terminal { };
    deepin-reader = callPackage ./apps/deepin-reader { };
    deepin-voice-note = callPackage ./apps/deepin-voice-note { };

    #### Go Packages
    go-lib = callPackage ./go-package/go-lib { inherit replaceAll; };
    go-gir-generator = callPackage ./go-package/go-gir-generator { };
    go-dbus-factory = callPackage ./go-package/go-dbus-factory { };
    dde-api = callPackage ./go-package/dde-api { inherit replaceAll; };
    deepin-pw-check = callPackage ./go-package/deepin-pw-check { };
    deepin-desktop-schemas = callPackage ./go-package/deepin-desktop-schemas { };

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
