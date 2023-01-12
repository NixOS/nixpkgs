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

    #### Dtk Application
    deepin-album = callPackage ./apps/deepin-album { };
    deepin-calculator = callPackage ./apps/deepin-calculator { };
    deepin-compressor = callPackage ./apps/deepin-compressor { };
    deepin-draw = callPackage ./apps/deepin-draw { };
    deepin-editor = callPackage ./apps/deepin-editor { };
    deepin-image-viewer = callPackage ./apps/deepin-image-viewer { };
    deepin-picker = callPackage ./apps/deepin-picker { };
    deepin-terminal = callPackage ./apps/deepin-terminal { };

    #### ARTWORK
    dde-account-faces = callPackage ./artwork/dde-account-faces { };
    deepin-icon-theme = callPackage ./artwork/deepin-icon-theme { };
    deepin-gtk-theme = callPackage ./artwork/deepin-gtk-theme { };
    deepin-sound-theme = callPackage ./artwork/deepin-sound-theme { };

    #### MISC
    deepin-desktop-base = callPackage ./misc/deepin-desktop-base { };
    deepin-turbo = callPackage ./misc/deepin-turbo { };
  };
in
lib.makeScope libsForQt5.newScope packages
