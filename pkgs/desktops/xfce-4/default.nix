{ callPackage, pkgs }:

rec {
  inherit (pkgs.gtkLibs) gtk glib;

  #### CORE

  exo = callPackage ./core/exo.nix {
    inherit (pkgs.perlPackages) URI;
    inherit (pkgs.gtkLibs) glib gtk;
  };

  libxfce4util = callPackage ./core/libxfce4util.nix {
    inherit (pkgs.gtkLibs) glib;
  };

  libxfcegui4 = callPackage ./core/libxfcegui4.nix {
    inherit (pkgs.gnome) libglade;
  };

  xfconf = callPackage ./core/xfconf.nix {
  };

  xfwm4 = callPackage ./core/xfwm4.nix {
    inherit (pkgs.gnome) libglade libwnck;
  };

  #### APPLICATIONS
  
  terminal = callPackage ./applications/terminal.nix {
    inherit (pkgs.gnome) vte;
    inherit (pkgs.gtkLibs) gtk;
  };

}
