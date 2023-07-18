{
  lib,
  llvmPackages,
  newScope,
}:

lib.makeScope newScope (
  self: with self; {
    stdenv = llvmPackages.stdenv;

    wrapGNUstepAppsHook = callPackage ./wrapGNUstepAppsHook.nix { };

    make = callPackage ./make { };

    libobjc = callPackage ./libobjc2 { };
    base = callPackage ./base { };
    back = callPackage ./back { };
    gui = callPackage ./gui { };

    gorm = callPackage ./gorm { };
    projectcenter = callPackage ./projectcenter { };
    system_preferences = callPackage ./systempreferences { };
    gworkspace = callPackage ./gworkspace { };
  }
)
