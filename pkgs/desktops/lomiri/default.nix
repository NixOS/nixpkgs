{ pkgs, makeScope, libsForQt5
}:

let
  packages = self: with self; {
    cmake-extras = callPackage ./cmake-extras { };
    libqtdbustest = callPackage ./libqtdbustest { };
    unity-api = callPackage ./unity-api { };
    geonames = callPackage ./geonames { };
  };
in makeScope libsForQt5.newScope packages
