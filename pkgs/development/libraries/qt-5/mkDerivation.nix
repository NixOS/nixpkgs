{ lib, debug, wrapQtAppsHook }:

let inherit (lib) optional; in

mkDerivation:

args:

let
  args_ = {

    qmakeFlags = [ ("CONFIG+=" + (if debug then "debug" else "release")) ]
              ++ (args.qmakeFlags or []);

    NIX_CFLAGS_COMPILE = toString (
      optional (!debug) "-DQT_NO_DEBUG"
      ++ lib.toList (args.NIX_CFLAGS_COMPILE or []));

    cmakeFlags =
      (args.cmakeFlags or [])
      ++ [
        ("-DCMAKE_BUILD_TYPE=" + (if debug then "Debug" else "Release"))
      ];

    enableParallelBuilding = args.enableParallelBuilding or true;

    nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ wrapQtAppsHook ];

  };
in

mkDerivation (args // args_)
