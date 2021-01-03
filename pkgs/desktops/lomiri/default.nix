{ pkgs, makeScope, libsForQt5
}:

let
  packages = self: with self; {
    cmake-extras = callPackage ./cmake-extras { };
  };
in makeScope libsForQt5.newScope packages
