{ pkgs, makeScope, libsForQt5 }:

let
  packages = self: with self; {
    updateScript = callPackage ./update.nix { };

    dbus-factory = callPackage ./dbus-factory { };
    dde-api = callPackage ./dde-api { };
    dde-calendar = callPackage ./dde-calendar { };
    dde-daemon = callPackage ./dde-daemon { };
    dde-qt-dbus-factory = callPackage ./dde-qt-dbus-factory { };
    dde-session-ui = callPackage ./dde-session-ui { };
    deepin-desktop-base = callPackage ./deepin-desktop-base { };
    deepin-desktop-schemas = callPackage ./deepin-desktop-schemas { };
    deepin-gettext-tools = callPackage ./deepin-gettext-tools { };
    deepin-gtk-theme = callPackage ./deepin-gtk-theme { };
    deepin-icon-theme = callPackage ./deepin-icon-theme { };
    deepin-image-viewer = callPackage ./deepin-image-viewer { };
    deepin-menu = callPackage ./deepin-menu { };
    deepin-metacity = callPackage ./deepin-metacity { };
    deepin-movie-reborn = callPackage ./deepin-movie-reborn { };
    deepin-mutter = callPackage ./deepin-mutter { };
    deepin-shortcut-viewer = callPackage ./deepin-shortcut-viewer { };
    deepin-sound-theme = callPackage ./deepin-sound-theme { };
    deepin-terminal = callPackage ./deepin-terminal {
      inherit (pkgs.gnome3) libgee;
      wnck = pkgs.libwnck3;
    };
    deepin-wallpapers = callPackage ./deepin-wallpapers { };
    deepin-wm = callPackage ./deepin-wm { };
    dtkcore = callPackage ./dtkcore { };
    dtkwm = callPackage ./dtkwm { };
    dtkwidget = callPackage ./dtkwidget { };
    go-dbus-factory = callPackage ./go-dbus-factory { };
    go-dbus-generator = callPackage ./go-dbus-generator { };
    go-gir-generator = callPackage ./go-gir-generator { };
    go-lib = callPackage ./go-lib { };
    qt5dxcb-plugin = callPackage ./qt5dxcb-plugin { };
    qt5integration = callPackage ./qt5integration { };

  };

in
  makeScope libsForQt5.newScope packages
