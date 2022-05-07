{ config, lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {

  lxappearance = callPackage ./core/lxappearance { };

  lxappearance-gtk2 = callPackage ./core/lxappearance {
    gtk2 = gtk2-x11;
    withGtk3 = false;
  };

  lxmenu-data = callPackage ./core/lxmenu-data { };

  lxpanel = callPackage ./core/lxpanel {
    gtk2 = gtk2-x11;
  };

  lxrandr = callPackage ./core/lxrandr { };

  lxsession = callPackage ./core/lxsession { };

  lxtask = callPackage ./core/lxtask { };
})
