{
  cuda_cudart ? null,
  lib,
  libcal ? null,
  libcublas ? null,
  libcusolver ? null,
  utils,
}:
let
  inherit (lib.attrsets) getLib;
  inherit (lib.lists) map;
in
prevAttrs: {
  badPlatformsConditions =
    prevAttrs.badPlatformsConditions
    // utils.mkMissingPackagesBadPlatformsConditions {
      inherit
        cuda_cudart
        libcal
        libcublas
        libcusolver
        ;
    };
  buildInputs =
    prevAttrs.buildInputs or [ ]
    ++ (map getLib [
      libcal
      libcublas
      libcusolver
      cuda_cudart
    ]);
}
