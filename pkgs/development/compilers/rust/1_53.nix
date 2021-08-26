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
, pkgsBuildTarget, pkgsBuildBuild, pkgsBuildHost
, makeRustPlatform
, llvmPackages_11
, llvmPackages_12, llvm_12
} @ args:

import ./default.nix {
  rustcVersion = "1.53.0";
  rustcSha256 = "1f95p259dfp5ca118bg107rj3rqwlswy65dxn3hg8sqgl4wwmxsw";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_12.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_12.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_12.libllvm.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_11;

  # For use at runtime
  llvmShared = llvm_12.override { enableSharedLibraries = true; };

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.52.1";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "c91f0431c8137a4e98e097ab47b49846820531aafb6e9c249b71b770771832e9";
    x86_64-unknown-linux-gnu = "617ae06e212cb65bc4abbf52b158b0328b9f1a6c2f822c27c95b274d6fbc0627";
    x86_64-unknown-linux-musl = "c3eae6e78ee29e03416897f89b54448b2a03d063f07a78cde41757ad2e02c2f0";
    arm-unknown-linux-gnueabihf = "ef412d923a0c5a9fa54422f40cde62f2e85a62339057cb8b986a545b108d3347";
    armv7-unknown-linux-gnueabihf = "ec47b3f5c801f8a4df7180e088dcc1817ee160df34ef64ddac4fa50f714f119f";
    aarch64-unknown-linux-gnu = "17d9aa7bb73b819ef70d81013498727b7218533ee6cf3bd802c4eac29137fbcb";
    aarch64-unknown-linux-musl = "f2bae2b32f05a90eec041352d9329deb3e907f5560b9fda525788df3b8008b6b";
    x86_64-apple-darwin = "cfa73228ea54e2c94f75d1b142ea41444c463f4ee8562a3eca1b11b2fe8af95a";
    aarch64-apple-darwin = "217e9723f828c5359467d69b363a342d702bdcbbcc4107be907e6bc4531f4912";
    powerpc64le-unknown-linux-gnu = "f258c5d7d6d9022108672b7383412d930a5f59d7644d148e413c3ab0ae45604f";
    riscv64gc-unknown-linux-gnu = "c1c98ccc8bb4147a819411a10162c8f8ce1aaa5c65cf2c74802dce4dacd6e64b";
  };

  selectRustPackage = pkgs: pkgs.rust_1_53;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_12" "llvm_12"])
