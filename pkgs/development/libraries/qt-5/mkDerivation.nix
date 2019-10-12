{ lib, debug, wrapQtAppsHook }:

let inherit (lib) optional; in

mkDerivation:

args:

let
  args_ = {

    enableParallelBuilding = args.enableParallelBuilding or true;

    nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ wrapQtAppsHook ];

  };
in

mkDerivation (args // args_)
