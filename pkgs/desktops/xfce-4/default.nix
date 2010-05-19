pkgs:
rec {
  inherit (pkgs.gtkLibs) gtk;

  #### CORE

  libexo = import ./core/libexo {
    inherit (pkgs) stdenv fetchurl pkgconfig;
    inherit (pkgs.gnome) intltool;
    inherit (pkgs.perlPackages) URI;
    inherit (pkgs.gtkLibs) glib gtk;
    inherit libxfce4util;
  };

  libxfce4util = import ./core/libxfce4util {
    inherit (pkgs) stdenv fetchurl pkgconfig;
    inherit (pkgs.gtkLibs) glib;
  };

  #### APPLICATIONS
  terminal = import ./applications/terminal {
    inherit (pkgs) stdenv fetchurl pkgconfig ncurses;
    inherit (pkgs.gnome) intltool vte;
    inherit (pkgs.gtkLibs) gtk;
    inherit libexo libxfce4util;
  };

}
