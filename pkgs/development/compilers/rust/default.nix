{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
  rustSnapshotPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./snapshot.nix {}));
in

rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "1.9.0";
    isRelease = true;
    forceBundledLLVM = false;
    configureFlags = [ "--release-channel=stable" ];
    srcRev = "e4e8b666850a763fdf1c3c2c142856ab51e32779";
    srcSha = "1pz4qx70mqv78fxm4w1mq7csk5pssq4qmr2vwwb5v8hyx03caff8";
    patches = [ ./patches/remove-uneeded-git.patch ]
      ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
    inherit targets;
    inherit targetPatches;
    inherit targetToolchains;
    rustPlatform = rustSnapshotPlatform;
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
