{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
in

rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "1.12.1";
    isRelease = true;
    forceBundledLLVM = false;
    configureFlags = [ "--release-channel=stable" ];
    srcRev = "d4f39402a0c2c2b94ec0375cd7f7f6d7918113cd";
    srcSha = "1lpykjy96rwz4jy28rf7ijca0q9lvckgnbzvcdsrspd5rs2ywfwr";

    patches = [
      ./patches/disable-lockfile-check.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;

    inherit targets;
    inherit targetPatches;
    inherit targetToolchains;
    inherit rustPlatform;
  };

  cargo = callPackage ./cargo.nix rec {
    version = "0.13.0";
    srcRev = "109cb7c33d426044d141457049bd0fffaca1327c";
    srcSha = "0p79m7hpzjh36l4fc6a59h6r8yz6qafjcdg5v1yb7bac9m2wi7vs";
    depsSha256 = "1cwp4p8b985fj8j2qmgsi2mpp51rdpwzm9qa60760nrry1fy624z";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
