{
  cudaAtLeast,
  lib,
  libcublas,
  libcusparse ? null,
  libnvjitlink ? null,
  utils,
}:
let
  inherit (lib.attrsets) getLib optionalAttrs;
in
prevAttrs: {
  badPlatformsConditions =
    prevAttrs.badPlatformsConditions
    // utils.mkMissingPackagesBadPlatformsConditions (
      optionalAttrs (cudaAtLeast "12.0") { inherit libnvjitlink; }
      // optionalAttrs (cudaAtLeast "12.1") { inherit libcusparse; }
    );

  buildInputs =
    prevAttrs.buildInputs
    # Always depends on this
    ++ [ (getLib libcublas) ]
    # Dependency from 12.0 and on
    ++ lib.lists.optionals (cudaAtLeast "12.0") [ (getLib libnvjitlink) ]
    # Dependency from 12.1 and on
    ++ lib.lists.optionals (cudaAtLeast "12.1") [ (getLib libcusparse) ];
}
