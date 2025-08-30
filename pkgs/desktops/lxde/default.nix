{
  config,
  lib,
  pkgs,
}:

lib.makeScope pkgs.newScope (
  self: with self; {

    inherit (pkgs) gtk2-x11;

    lxappearance = callPackage ./core/lxappearance { };

    lxappearance-gtk2 = callPackage ./core/lxappearance {
      gtk2 = gtk2-x11;
      withGtk3 = false;
    };

    lxmenu-data = callPackage ./core/lxmenu-data { };

    lxpanel = throw "'lxpanel' has been moved to top-level."; # added 2025-08-31

    lxrandr = throw "'lxrandr' has been moved to top-level."; # added 2025-08-31

    lxsession = throw "'lxsession' has been moved to top-level."; # added 2025-08-31

    lxtask = callPackage ./core/lxtask { };
  }
)
