{
  config,
  lib,
  pkgs,
}:

lib.makeScope pkgs.newScope (
  self: with self; {

    gtk2-x11 = throw "'lxde.gtk2-x11' has been removed. Use 'gtk2-x11' directly."; # added 2025-08-31

    lxappearance = throw "'lxappearance' has been moved to top-level."; # added 2025-08-31

    lxappearance-gtk2 = throw "'lxappearance-gtk2' has been moved to top-level."; # added 2025-08-31

    lxmenu-data = throw "'lxmenu-data' has been moved to top-level."; # added 2025-08-31

    lxpanel = throw "'lxpanel' has been moved to top-level."; # added 2025-08-31

    lxrandr = throw "'lxrandr' has been moved to top-level."; # added 2025-08-31

    lxsession = throw "'lxsession' has been moved to top-level."; # added 2025-08-31

    lxtask = throw "'lxtask' has been moved to top-level."; # added 2025-08-31
  }
)
