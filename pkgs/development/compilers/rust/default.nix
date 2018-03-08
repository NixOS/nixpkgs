{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform, llvm, fetchurl
, fetchpatch
, targets ? []
, targetToolchains ? []
, targetPatches ? []
}:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
  version = "1.24.1";
  cargoVersion = "0.24.0";
  src = fetchurl {
    url = "https://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
    sha256 = "1vv10x2h9kq7fxh2v01damdq8pvlp5acyh1kzcda9sfjx12kv99y";
  };
in rec {
  rustc = callPackage ./rustc.nix {
    inherit stdenv llvm targets targetPatches targetToolchains rustPlatform version src;

    forceBundledLLVM = true;

    configureFlags = [ "--release-channel=stable" ];

    patches = [
      ./patches/0001-Disable-fragile-tests-libstd-net-tcp-on-Darwin-Linux.patch
      # Adapted from https://github.com/rust-lang/rust/pull/47912
      (fetchpatch {
        url = "https://src.fedoraproject.org/rpms/rust/raw/1bb4d24c060915c304c9a9f86a438388e599f9c6/f/0002-Use-a-range-to-identify-SIGSEGV-in-stack-guards.patch";
        sha256 = "16hc170qzzcb9lcabk0ln005zji2h1gq0knbr9avbbzlbg9jha2q";
      })
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
