{ callPackage, pkgs }:

rec {
  inherit (pkgs.gtkLibs) gtk glib;

  #### SUPPORT

  # The useful bits from ‘gnome-disk-utility’.
  libgdu = callPackage ./support/libgdu.nix { };  

  # Gvfs is required by Thunar for the trash feature and for volume
  # mounting.  Should use the one from Gnome, but I don't want to mess
  # with the Gnome packages (or pull in a zillion Gnome dependencies).
  gvfs = callPackage ./support/gvfs.nix { };

  
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

  thunar_volman = callPackage ./core/thunar-volman.nix { };

  gtk_xfce_engine = callPackage ./core/gtk-xfce-engine.nix { };

  xfce4_appfinder = callPackage ./core/xfce4-appfinder.nix { };


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
