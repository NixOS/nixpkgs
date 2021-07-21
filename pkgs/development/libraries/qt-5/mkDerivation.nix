{ stdenv, lib, debug, wrapQtAppsHook }:

let inherit (lib) optional; in

mkDerivation:

args:

let
  args_ = {

    nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ wrapQtAppsHook ];

  } // lib.optionalAttrs stdenv.isDarwin { qtWrapAllExecutables = true; };
in

mkDerivation (args // args_)
