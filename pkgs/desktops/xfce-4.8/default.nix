{ callPackage, pkgs }:

rec {
  inherit (pkgs.gtkLibs) gtk glib;

  #### CORE

  libxfce4util = callPackage ./core/libxfce4util.nix { };

  exo = callPackage ./core/exo.nix {
    inherit (pkgs.perlPackages) URI;
  };

  xfconf = callPackage ./core/xfconf.nix { };
  
  libxfcegui4 = callPackage ./core/libxfcegui4.nix {
    inherit (pkgs.gnome) libglade;
  };

  libxfce4ui = callPackage ./core/libxfce4ui.nix { };

  xfwm4 = callPackage ./core/xfwm4.nix {
    inherit (pkgs.gnome) libwnck;
  };

  xfceutils = callPackage ./core/xfce-utils.nix { };

  garcon = callPackage ./core/garcon.nix { };

  xfce4panel = callPackage ./core/xfce4-panel.nix {
    inherit (pkgs.gnome) libwnck;
  };

  xfce4session = callPackage ./core/xfce4-session.nix {
    inherit (pkgs.gnome) libwnck;
  };

  xfce4settings = callPackage ./core/xfce4-settings.nix { };

  xfdesktop = callPackage ./core/xfdesktop.nix {
    inherit (pkgs.gnome) libwnck;
  };

  thunar = callPackage ./core/thunar.nix { };

  gtk_xfce_engine = callPackage ./core/gtk-xfce-engine.nix { };

  # !!! Add xfce4-appfinder

  #### APPLICATIONS
  
  terminal = callPackage ./applications/terminal.nix {
    inherit (pkgs.gnome) vte;
  };

  mousepad = callPackage ./applications/mousepad.nix { };

  ristretto = callPackage ./applications/ristretto.nix { };

  xfce4_power_manager = callPackage ./applications/xfce4-power-manager.nix { };

  xfce4mixer = callPackage ./applications/xfce4-mixer.nix { };

  #### ART

  xfce4icontheme = callPackage ./art/xfce4-icon-theme.nix { };
  
}
