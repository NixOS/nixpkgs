{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform, llvm, fetchurl
, targets ? []
, targetToolchains ? []
, targetPatches ? []
}:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
  version = "1.25.0";
  cargoVersion = "0.26.0";
  src = fetchurl {
    url = "https://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
    sha256 = "0baxjr99311lvwdq0s38bipbnj72pn6fgbk6lcq7j555xq53mxpf";
  };
in rec {
  rustc = callPackage ./rustc.nix {
    inherit stdenv llvm targets targetPatches targetToolchains rustPlatform version src;

    forceBundledLLVM = true;

    configureFlags = [ "--release-channel=stable" ];

    patches = [
      ./patches/0001-Disable-fragile-tests-libstd-net-tcp-on-Darwin-Linux.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch
      # https://github.com/rust-lang/rust/issues/45410
      ++ stdenv.lib.optional stdenv.isAarch64 ./patches/aarch64-disable-test_loading_cosine.patch;

  };

  cargo = callPackage ./cargo.nix rec {
    version = cargoVersion;
    inherit src;
    inherit stdenv;
    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
