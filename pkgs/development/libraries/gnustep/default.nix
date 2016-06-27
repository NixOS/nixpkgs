{ pkgs, newScope }:

let
  callPackage = newScope self;

  self = rec {
    stdenv = pkgs.clangStdenv;

    gsmakeDerivation = callPackage ./make/gsmakeDerivation.nix {};
    gorm = callPackage ./gorm {};
    projectcenter = callPackage ./projectcenter {};
    system_preferences = callPackage ./systempreferences {};
    libobjc2 = callPackage ./libobjc2 {};
    make = callPackage ./make {};
    xcode = callPackage ./xcode {};
    back = callPackage ./back {};
    base = callPackage ./base { giflib = pkgs.giflib_4_1; };
    gui = callPackage ./gui {};
    gworkspace = callPackage ./gworkspace {};
  };

in self
