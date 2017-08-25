{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform, llvm, fetchurl
, targets ? []
, targetToolchains ? []
, targetPatches ? []
}:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
  version = "1.17.0";
in
rec {
  rustc = callPackage ./rustc.nix {
    inherit llvm targets targetPatches targetToolchains rustPlatform version;

    configureFlags = [ "--release-channel=stable" ];

    src = fetchurl {
      url = "https://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
      sha256 = "4baba3895b75f2492df6ce5a28a916307ecd1c088dc1fd02dbfa8a8e86174f87";
    };

    patches = [
      ./patches/darwin-disable-fragile-tcp-tests.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;

  };

  cargo = callPackage ./cargo.nix rec {
    version = "0.18.0";
    srcRev = "fe7b0cdcf5ca7aab81630706ce40b70f6aa2e666";
    srcSha = "164iywv1l3v87b0pznf5kkzxigd6w19myv9d7ka4c65zgrk9n9px";
    depsSha256 = "1ydlsxnklanmg0zskcxg9cfw0j0fvgncjvccirzml3h4cnl8ji5j";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
