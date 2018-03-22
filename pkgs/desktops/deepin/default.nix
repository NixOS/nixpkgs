{ pkgs, newScope }:

let
  callPackage = newScope self;

  self = rec {

    deepin-gtk-theme = callPackage ./deepin-gtk-theme { };

    deepin-icon-theme = callPackage ./deepin-icon-theme { };

    deepin-terminal = callPackage ./deepin-terminal {
      inherit (pkgs.gnome3) libgee vte;
      wnck = pkgs.libwnck3;
    };

  };

in self
