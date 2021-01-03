{ pkgs, makeScope, libsForQt5
}:

let
  packages = self: with self; {
    cmake-extras = callPackage ./cmake-extras { };
    libqtdbustest = callPackage ./libqtdbustest { };
  };
in makeScope libsForQt5.newScope packages
