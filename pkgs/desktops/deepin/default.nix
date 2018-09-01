{ pkgs, makeScope, libsForQt5 }:

let
  packages = self: with self; {

    deepin-gtk-theme = callPackage ./deepin-gtk-theme { };
    deepin-icon-theme = callPackage ./deepin-icon-theme { };
    deepin-terminal = callPackage ./deepin-terminal {
      inherit (pkgs.gnome3) libgee vte;
      wnck = pkgs.libwnck3;
    };
    dtkcore = callPackage ./dtkcore { };

  };

in
  makeScope libsForQt5.newScope packages
