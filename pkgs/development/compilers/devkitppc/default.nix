{ symlinkJoin
, callPackage
, lib
, devkitPPC-rules
, devkitPPC-gcc
}:

let
  sources = callPackage ./sources.nix { };
in symlinkJoin {
  name = "devkitPPC-r${sources.buildscripts.version}";

  paths = [
    devkitPPC-rules
    devkitPPC-gcc
  ];

  meta = {
    description = "Toolchain for Nintendo Gamecube & Wii homebrew development";
    homepage = "https://github.com/devkitPro/buildscripts";
    maintainers = [ lib.maintainers.novenary ];
    platforms = lib.platforms.unix;
  };
}
