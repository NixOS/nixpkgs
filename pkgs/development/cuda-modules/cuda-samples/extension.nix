{
  cudaMajorMinorVersion,
  lib,
  stdenv,
}:
let
  cudaVersionToHash = {
    "11.8" = "sha256-7+1P8+wqTKUGbCUBXGMDO9PkxYr2+PLDx9W2hXtXbuc=";
    "12.0" = "sha256-Lj2kbdVFrJo5xPYPMiE4BS7Z8gpU5JLKXVJhZABUe/g=";
    "12.1" = "sha256-xE0luOMq46zVsIEWwK4xjLs7NorcTIi9gbfZPVjIlqo=";
    "12.2" = "sha256-pOy0qfDjA/Nr0T9PNKKefK/63gQnJV2MQsN2g3S2yng=";
    "12.3" = "sha256-fjVp0G6uRCWxsfe+gOwWTN+esZfk0O5uxS623u0REAk=";
  };

  inherit (stdenv) hostPlatform;

  # Samples are built around the CUDA Toolkit, which is not available for
  # aarch64. Check for both CUDA version and platform.
  cudaVersionIsSupported = cudaVersionToHash ? ${cudaMajorMinorVersion};
  platformIsSupported = hostPlatform.isx86_64;
  isSupported = cudaVersionIsSupported && platformIsSupported;

  # Build our extension
  extension =
    final: _:
    lib.attrsets.optionalAttrs isSupported {
      cuda-samples = final.callPackage ./generic.nix {
        hash = cudaVersionToHash.${cudaMajorMinorVersion};
      };
    };
in
extension
