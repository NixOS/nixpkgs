{
  cudaAtLeast,
  lib,
  libnvjitlink ? null,
  utils,
}:
let
  inherit (lib.attrsets) optionalAttrs;
in
prevAttrs: {
  badPlatformsConditions =
    prevAttrs.badPlatformsConditions
    // utils.mkMissingPackagesBadPlatformsConditions (
      optionalAttrs (cudaAtLeast "12.0") { inherit libnvjitlink; }
    );

  buildInputs =
    prevAttrs.buildInputs
    # Dependency from 12.0 and on
    ++ lib.lists.optionals (cudaAtLeast "12.0") [ libnvjitlink.lib ];
}
