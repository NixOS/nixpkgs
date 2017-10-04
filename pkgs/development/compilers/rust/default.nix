{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform, llvm, fetchurl
, targets ? []
, targetToolchains ? []
, targetPatches ? []
}:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
  version = "1.20.0";
in
rec {
  rustc = callPackage ./rustc.nix {
    inherit llvm targets targetPatches targetToolchains rustPlatform version;

    forceBundledLLVM = true;

    configureFlags = [ "--release-channel=stable" ];

    src = fetchurl {
      url = "https://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
      sha256 = "0542y4rnzlsrricai130mqyxl8r6rd991frb4qsnwb27yigqg91a";
    };

    patches = [
      ./patches/darwin-disable-fragile-tcp-tests.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;

  };

  cargo = callPackage ./cargo.nix rec {
    version = "0.21.1";
    srcSha = "a64iywv1l3v87b0pznf5kkzxigd6w19myv9d7ka4c65zgrk9n9px";
    depsSha256 = "amrgd8ib48vxxbhkvsqqq4p19sc6b74x3cd8p6lhhlm6plrajrvm";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
