{ lib, debug, wrapQtAppsHook }:

let inherit (lib) optional; in

mkDerivation:

args:

let
  args_ = {

    NIX_CFLAGS_COMPILE = toString (
      optional (!debug) "-DQT_NO_DEBUG"
      ++ lib.toList (args.NIX_CFLAGS_COMPILE or []));

    enableParallelBuilding = args.enableParallelBuilding or true;

    nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ wrapQtAppsHook ];

  };
in

mkDerivation (args // args_)
