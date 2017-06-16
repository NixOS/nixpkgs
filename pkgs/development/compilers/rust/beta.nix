{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform, llvm, fetchurl
, targets ? []
, targetToolchains ? []
, targetPatches ? []
}:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
in
rec {
  rustc = callPackage ./rustc.nix {
    inherit llvm targets targetPatches targetToolchains rustPlatform;

    version = "beta-2017-05-27";

    configureFlags = [ "--release-channel=beta" ];

    src = fetchurl {
      url = "https://static.rust-lang.org/dist/2017-05-27/rustc-beta-src.tar.gz";
      sha256 = "9f3f92efef7fb2b4bf38e57e4ff1f416dc221880b90841c4bdaee350801c0b57";
    };

    patches = [
      ./patches/darwin-disable-fragile-tcp-tests.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;

    doCheck = false;
  };

  cargo = callPackage ./cargo.nix rec {
    version = "0.18.0";
    srcRev = "fe7b0cdcf5ca7aab81630706ce40b70f6aa2e666";
    srcSha = "164iywv1l3v87b0pznf5kkzxigd6w19myv9d7ka4c65zgrk9n9px";
    depsSha256 = "1mrgd8ib48vxxbhkvsqqq4p19sc6b74x3cd8p6lhhlm6plrajrvm";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
