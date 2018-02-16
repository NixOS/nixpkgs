{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform, llvm, fetchurl
, targets ? []
, targetToolchains ? []
, targetPatches ? []
}:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
  version = "1.22.1";
  cargoVersion = "0.23.0";
  src = fetchurl {
      url = "https://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
      sha256 = "1lrzzp0nh7s61wgfs2h6ilaqi6iq89f1pd1yaf65l87bssyl4ylb";
  };
  # patches that apply to both cargo and rustc
  commonPatches = [
    # this patch can be removed when rustc is upgraded to 1.23
    ./patches/1.22.1-update-vendored-jobserver.patch
  ];
in rec {
  rustc = callPackage ./rustc.nix {
    inherit llvm targets targetPatches targetToolchains rustPlatform version src;

    forceBundledLLVM = true;

    configureFlags = [ "--release-channel=stable" ];

    patches = [
      ./patches/0001-Disable-fragile-tests-libstd-net-tcp-on-Darwin-Linux.patch
    ] ++ commonPatches ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch
      # https://github.com/rust-lang/rust/issues/45410
      ++ stdenv.lib.optional stdenv.isAarch64 ./patches/aarch64-disable-test_loading_cosine.patch;

  };

  cargo = callPackage ./cargo.nix rec {
    version = cargoVersion;
    patches = commonPatches;
    inherit src;
    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
