{
  cuda_cudart ? null,
  lib,
  utils,
}:
let
  inherit (lib.attrsets) getLib;
  inherit (lib.lists) optionals;
  inherit (lib.strings) versionOlder;
in
finalAttrs: prevAttrs: {
  badPlatformsConditions =
    prevAttrs.badPlatformsConditions
    // utils.mkMissingPackagesBadPlatformsConditions { inherit cuda_cudart; };
  buildInputs =
    prevAttrs.buildInputs or [ ]
    ++ optionals (versionOlder finalAttrs.version "0.4") [ (getLib cuda_cudart) ];
}
