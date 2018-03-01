{ pkgs, newScope }:

let
  callPackage = newScope self;

  self = rec {

    deepin-terminal = callPackage ./deepin-terminal {
      inherit (pkgs.gnome3) libgee vte;
      wnck = pkgs.libwnck3;
    };

  };

in self
