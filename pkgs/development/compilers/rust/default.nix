{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform, llvm, fetchurl
, targets ? []
, targetToolchains ? []
, targetPatches ? []
}:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
  version = "1.19.0";
in
rec {
  rustc = callPackage ./rustc.nix {
    inherit llvm targets targetPatches targetToolchains rustPlatform version;

    configureFlags = [ "--release-channel=stable" ];

    src = fetchurl {
      url = "https://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
      sha256 = "15231f5053fb72ad82be91f5abfd6aa60cb7898c5089e4f1ac5910a731090c51";
    };

    patches = [
      ./patches/darwin-disable-fragile-tcp-tests.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;

  };

  cargo = callPackage ./cargo.nix rec {
    version = "0.20.0";
    srcRev = "a60d185c878c470876e123b0e40b0ba9f3271163";
    srcSha = "0j6i2ak1zlwfhz0d1hsrzislgvajdqc8kdfdn242lim9dar81swp";
    depsSha256 = "1n42mcgwx5pxzgy2xzimrap3gjy90a8q7bb65k5pw8z3jrss91ck";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
