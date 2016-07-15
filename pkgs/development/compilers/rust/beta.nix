{ stdenv, callPackage, rustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "beta-1.10.0";
    forceBundledLLVM = false;
    configureFlags = [ "--release-channel=beta" ];
    srcRev = "d18e321abeecc69e4d1bf9cafba4fba53ddf267d";
    srcSha = "1ck8mbjrq0bzq5xzwgaqdilakwm2ab0xpzqibjycds62ad4yw774";
    patches = [ ./patches/disable-lockfile-check.patch ]
      ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
    inherit targets;
    inherit targetPatches;
    inherit targetToolchains;
    inherit rustPlatform;
  };

  cargo = callPackage ./cargo.nix rec {
    version = "0.10.0";
    srcRev = "refs/tags/${version}";
    srcSha = "06scvx5qh60mgvlpvri9ig4np2fsnicsfd452fi9w983dkxnz4l2";
    depsSha256 = "0js4697n7v93wnqnpvamhp446w58llj66za5hkd6wannmc0gsy3b";
    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
