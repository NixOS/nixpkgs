{ pkgs, makeScope, libsForQt5 }:

let
  packages = self: with self; {

    dde-qt-dbus-factory = callPackage ./dde-qt-dbus-factory { };
    deepin-gettext-tools = callPackage ./deepin-gettext-tools { };
    deepin-gtk-theme = callPackage ./deepin-gtk-theme { };
    deepin-icon-theme = callPackage ./deepin-icon-theme { };
    deepin-terminal = callPackage ./deepin-terminal {
      inherit (pkgs.gnome3) libgee vte;
      wnck = pkgs.libwnck3;
    };
    dtkcore = callPackage ./dtkcore { };
    dtkwidget = callPackage ./dtkwidget { };
    qt5dxcb-plugin = callPackage ./qt5dxcb-plugin { };
    qt5integration = callPackage ./qt5integration { };

  };

in
  makeScope libsForQt5.newScope packages
