{
  lib,
  libcufft,
  libcurand,
  libGLU,
  libglut,
  libglvnd,
  mesa,
}:
let
  inherit (lib.attrsets) getLib;
  inherit (lib.lists) map;
in
prevAttrs: {
  buildInputs =
    prevAttrs.buildInputs
    ++ (map getLib [
      libcufft
      libcurand
    ])
    ++ [
      libGLU
      libglut
      libglvnd
      mesa
    ];
}
