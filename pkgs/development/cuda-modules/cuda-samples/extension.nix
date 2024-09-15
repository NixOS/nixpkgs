{
  cudaVersion,
  lib,
  stdenv,
}:
let
  cudaVersionToHash = {
    "10.0" = "sha256-XAI6iiPpDVbZtFoRaP1s6VKpu9aV3bwOqqkw33QncP8=";
    "10.1" = "sha256-DY8E2FKCFj27jPgQEB1qE9HcLn7CfSiVGdFm+yFQE+k=";
    "10.2" = "sha256-JDW4i7rC2MwIRvKRmUd6UyJZI9bWNHqZijrB962N4QY=";
    "11.0" = "sha256-BRwQuUvJEVi1mTbVtGODH8Obt7rXFfq6eLH9wxCTe9g=";
    "11.1" = "sha256-kM8gFItBaTpkoT34vercmQky9qTFtsXjXMGjCMrsUc4=";
    "11.2" = "sha256-gX6V98dRwdAQIsvru2byDLiMswCW2lrHSBSJutyWONw=";
    "11.3" = "sha256-34MdMFS2cufNbZVixFdSUDFfLeuKIGFwLBL9d81acU0=";
    "11.4" = "sha256-Ewu+Qk6GtGXC37CCn1ZXHc0MQAuyXCGf3J6T4cucTSA=";
    "11.5" = "sha256-AKRZbke0K59lakhTi8dX2cR2aBuWPZkiQxyKaZTvHrI=";
    "11.6" = "sha256-AsLNmAplfuQbXg9zt09tXAuFJ524EtTYsQuUlV1tPkE=";
    # The tag 11.7 of cuda-samples does not exist
    "11.8" = "sha256-7+1P8+wqTKUGbCUBXGMDO9PkxYr2+PLDx9W2hXtXbuc=";
    "12.0" = "sha256-Lj2kbdVFrJo5xPYPMiE4BS7Z8gpU5JLKXVJhZABUe/g=";
    "12.1" = "sha256-xE0luOMq46zVsIEWwK4xjLs7NorcTIi9gbfZPVjIlqo=";
    "12.2" = "sha256-pOy0qfDjA/Nr0T9PNKKefK/63gQnJV2MQsN2g3S2yng=";
    "12.3" = "sha256-fjVp0G6uRCWxsfe+gOwWTN+esZfk0O5uxS623u0REAk=";
  };

  inherit (stdenv) hostPlatform;

  # Samples are built around the CUDA Toolkit, which is not available for
  # aarch64. Check for both CUDA version and platform.
  cudaVersionIsSupported = cudaVersionToHash ? ${cudaVersion};
  platformIsSupported = hostPlatform.isx86_64;
  isSupported = cudaVersionIsSupported && platformIsSupported;

  # Build our extension
  extension =
    final: _:
    lib.attrsets.optionalAttrs isSupported {
      cuda-samples = final.callPackage ./generic.nix {
        inherit cudaVersion;
        hash = cudaVersionToHash.${cudaVersion};
      };
    };
in
extension
