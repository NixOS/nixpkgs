{ stdenv, callPackage, rustPlatform, llvm, fetchurl
, targets ? []
, targetToolchains ? []
, targetPatches ? []
}:

rec {
  rustc = callPackage ./rustc.nix {
    inherit llvm targets targetPatches targetToolchains rustPlatform;

    version = "nightly-2017-05-30";

    configureFlags = [ "--release-channel=nightly" ];

    src = fetchurl {
      url = "https://static.rust-lang.org/dist/2017-05-30/rustc-nightly-src.tar.gz";
      sha256 = "90ce76db56a93f1b4532f2e62bbf12c243c4d156662b0d80c25319211ee7d0e0";
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
