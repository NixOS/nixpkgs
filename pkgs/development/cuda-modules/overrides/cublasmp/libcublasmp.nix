{
  lib,
  libcal ? null,
  libcublas ? null,
  utils,
}:
let
  inherit (lib.attrsets) getLib;
  inherit (lib.lists) map;
in
prevAttrs: {
  badPlatformsConditions =
    prevAttrs.badPlatformsConditions
    // utils.mkMissingPackagesBadPlatformsConditions { inherit libcal libcublas; };
  # TODO: Looks like the minimum supported capability is 7.0 as of the latest:
  # https://docs.nvidia.com/cuda/cublasmp/getting_started/index.html
  buildInputs =
    prevAttrs.buildInputs or [ ]
    ++ (map getLib [
      libcal
      libcublas
    ]);
}
