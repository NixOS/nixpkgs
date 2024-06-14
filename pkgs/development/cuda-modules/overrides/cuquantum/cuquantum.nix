{
  cudaOlder,
  cudaPackages,
  lib,
  libcublas ? null,
  libcusolver ? null,
  utils,
}:
finalAttrs: prevAttrs:
let
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.lists) optionals;
  inherit (lib.strings) versionAtLeast;
  inherit (lib.versions) majorMinor;
  desiredLibCuTensorName =
    # Version 24.03.0 of cuquantum is the first to support libcutensor.so.2, so we can use the default (newest)
    # version of libcutensor in the package set.
    if versionAtLeast finalAttrs.version "24.03.0" then
      "libcutensor"

    # Versions prior only support libcutensor.so.1.
    else
      "libcutensor_1";

  libcutensor = cudaPackages.${desiredLibCuTensorName} or null;

  # For some reason, only version 22.11 of cuquantum requires libcusparse.
  requiresLibCuSparse = majorMinor finalAttrs.version == "22.11";
  libcusparse = cudaPackages.libcusparse or null;
in
{
  badPlatformsConditions =
    prevAttrs.badPlatformsConditions
    // utils.mkMissingPackagesBadPlatformsConditions (
      {
        inherit libcublas libcusolver;
        ${desiredLibCuTensorName} = libcutensor;
      }
      // optionalAttrs requiresLibCuSparse { inherit libcusparse; }
    );
  buildInputs =
    prevAttrs.buildInputs or [ ]
    ++ [
      libcublas.lib
      libcusolver.lib
      libcutensor.lib
    ]
    ++ optionals requiresLibCuSparse [ libcusparse.lib ];
}
