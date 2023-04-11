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
, CoreFoundation, Security, SystemConfiguration
, pkgsBuildTarget, pkgsBuildBuild, pkgsBuildHost
, makeRustPlatform
, llvmPackages_11
, llvmPackages_15, llvm_15
, fetchpatch
} @ args:

import ./default.nix {
  rustcVersion = "1.68.2";
  rustcSha256 = "sha256-kzOcI/fNTQxF21jhi0xuFtYHD0J3qtnSSS0jKUvzLpY=";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_15.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_15.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_15.libllvm.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_11;

  # For use at runtime
  llvmShared = llvm_15.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackages = llvmPackages_15;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.67.1";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "4fe2128cfc32687e4717da4c6cb21aa563c36802c8e695cd3537a45efc5b8729";
    x86_64-unknown-linux-gnu = "652a8966436c4e97b127721d9130810e1cdc8dfdf526fad68c9c1f6281bd02a3";
    x86_64-unknown-linux-musl = "6fdc9379f662f8e9edd2d23e0a3ebcda502cc9f9a381b7c7d5fa38c326a82ad1";
    arm-unknown-linux-gnueabihf = "eb919ef62a084797c148574abe39f2fb1e52d20b004041090811a6d479eb6503";
    armv7-unknown-linux-gnueabihf = "09614988feb6310f64eaadf609c92dba5da5ebdbb5531b43a2b18d5336296b67";
    aarch64-unknown-linux-gnu = "8edee248eed4b17c09b3d7b0096944b7e5992dd1119a28429c0b6b4d39a9613c";
    aarch64-unknown-linux-musl = "05d03936493c19483eec4dc63d03f9e7a13f356d1147d1b8d7fc5dbfe508b4ed";
    x86_64-apple-darwin = "020702c9564f53e18ac880db77c2f6b660a24ea372e4fda3f0c1ef2f8b9c74b9";
    aarch64-apple-darwin = "8b07560267ec85703a5a9397a1746170fd7013e29fcfb9ffb8daa9bbf1e3211a";
    powerpc64le-unknown-linux-gnu = "1d4d8b75c72362bb6e02bf56b53af9287806c4ef08187b8d166af0557a7c0096";
    riscv64gc-unknown-linux-gnu = "a1a33154aeb5498c0c24a2ba77ec63e31a40df5e0861c0afda8d5867289c5984";
    mips64el-unknown-linux-gnuabi64 = "6d70fe81e4f52ce5d87bcf95b60587f43f68e6730d2def7872646a9c561017ca";
  };

  selectRustPackage = pkgs: pkgs.rust_1_68;

  rustcPatches = [
    # Fixes ICE.
    # https://github.com/rust-lang/rust/pull/107688
    (fetchpatch {
      name = "re-erased-regions-are-local.patch";
      url = "https://github.com/rust-lang/rust/commit/9d110847ab7f6aef56a8cd20cb6cea4fbcc51cd9.patch";
      excludes = [ "*tests/*" ];
      hash = "sha256-EZH5K1BEOOfi97xZr1xEHFP4jjvJ1+xqtRMvxBoL8pU=";
    })
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_15" "llvm_15"])
