{ hostPlatform, lib }:
let
  # Samples are built around the CUDA Toolkit, which is not available for
  # aarch64. Check for both CUDA version and platform.
  platformIsSupported = hostPlatform.isx86_64 && hostPlatform.isLinux;

  # Build our extension
  extension =
    final: _:
    lib.attrsets.optionalAttrs platformIsSupported {
      cuda-library-samples = final.callPackage ./generic.nix { };
    };
in
extension
