{ wrapQtAppsHook }:

mkDerivation:

args:

let
  args_ = {

    nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ wrapQtAppsHook ];

  };
in

mkDerivation (args // args_)
