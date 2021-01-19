{ newScope
, llvmPackages
, giflib_4_1
}:

let
  callPackage = newScope self;

  self = rec {
    stdenv = llvmPackages.stdenv;

    gsmakeDerivation = callPackage ./make/gsmakeDerivation.nix {};
    gorm = callPackage ./gorm {};
    projectcenter = callPackage ./projectcenter {};
    system_preferences = callPackage ./systempreferences {};
    libobjc = callPackage ./libobjc2 {};
    make = callPackage ./make {};
    back = callPackage ./back {};
    base = callPackage ./base { giflib = giflib_4_1; };
    gui = callPackage ./gui {};
    gworkspace = callPackage ./gworkspace {};
  };

in self
