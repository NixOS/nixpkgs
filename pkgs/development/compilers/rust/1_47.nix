# New rust versions should first go to staging.
# Things to check after updating:
# 1. Rustc should produce rust binaries on x86_64-linux, aarch64-linux and x86_64-darwin:
#    i.e. nix-shell -p fd or @GrahamcOfBorg build fd on github
#    This testing can be also done by other volunteers as part of the pull
#    request review, in case platforms cannot be covered.
# 2. The LLVM version used for building should match with rust upstream.
#    Check the version number in the src/llvm-project git submodule in:
#    https://github.com/rust-lang/rust/blob/<version-tag>/.gitmodules
# 3. Firefox and Thunderbird should still build on x86_64-linux.

{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages
, pkgsBuildTarget, pkgsBuildBuild
, makeRustPlatform
} @ args:

import ./default.nix {
  rustcVersion = "1.47.0";
  rustcSha256 = "sha256-MYXfBkxHR/LIubuMRGjt1Y/0rW0HiAyHmsGxc7do2B0=";

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.46.0";

  # fetch hashes by running `print-hashes.sh 1.45.2`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "6ebd7e04dc18a36d08b9731cdb42d5caf8460e1eb41b75f3a8596c39f5e71206";
    x86_64-unknown-linux-gnu = "e3b98bc3440fe92817881933f9564389eccb396f5f431f33d48b979fa2fbdcf5";
    arm-unknown-linux-gnueabihf = "bb8af68565321f54608e918597083eb016ed0f9f4f3cc23f7cc5f467b934ce7f";
    armv7-unknown-linux-gnueabihf = "7c0640879d7f2c38db60352e3c0f09e3fc6fa3bac6ca8f22cbccb1eb5e950121";
    aarch64-unknown-linux-gnu = "f0c6d630f3dedb3db69d69ed9f833aa6b472363096f5164f1068c7001ca42aeb";
    x86_64-apple-darwin = "82d61582a3772932432a99789c3b3bd4abe6baca339e355048ca9efb9ea5b4db";
    powerpc64le-unknown-linux-gnu = "89e2f4761d257f017a4b6aa427f36ac0603195546fa2cfded8c899789832941c";
  };

  selectRustPackage = pkgs: pkgs.rust_1_47;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" ])
