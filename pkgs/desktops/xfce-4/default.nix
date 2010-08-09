{ callPackage, pkgs }:

rec {
  inherit (pkgs.gtkLibs) gtk glib;

  #### CORE

  exo = callPackage ./core/exo.nix {
    inherit (pkgs.perlPackages) URI;
  };

  libxfce4util = callPackage ./core/libxfce4util.nix { };

  libxfcegui4 = callPackage ./core/libxfcegui4.nix {
    inherit (pkgs.gnome) libglade;
  };

  xfconf = callPackage ./core/xfconf.nix { };

  xfwm4 = callPackage ./core/xfwm4.nix {
    inherit (pkgs.gnome) libglade libwnck;
  };

  xfceutils = callPackage ./core/xfce-utils.nix { };

  xfce4session = callPackage ./core/xfce4-session.nix {
    inherit (pkgs.gnome) libglade libwnck;
  };

  xfce4panel = callPackage ./core/xfce4-panel.nix {
    inherit (pkgs.gnome) libwnck;
  };

  xfdesktop = callPackage ./core/xfdesktop.nix {
    inherit (pkgs.gnome) libwnck libglade;
  };

  #### APPLICATIONS
  
  terminal = callPackage ./applications/terminal.nix {
    inherit (pkgs.gnome) vte;
  };

}
