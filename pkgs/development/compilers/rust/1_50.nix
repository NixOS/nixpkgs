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
, llvmPackages_5, llvm_11
} @ args:

import ./default.nix {
  rustcVersion = "1.50.0";
  rustcSha256 = "0pjs7j62maiyvkmhp9zrxl528g2n0fphp4rq6ap7aqdv0a6qz5wm";

  llvmSharedForBuild = pkgsBuildBuild.llvm_11.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvm_11.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvm_11.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_5;

  # For use at runtime
  llvmShared = llvm_11.override { enableSharedLibraries = true; };

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.49.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "5371bfa2c8e566aa283acdfa93d24b981c789d7c040ac1ca74e76bff1c7f6598";
    x86_64-unknown-linux-gnu = "8b14446df82f3707d69cf58fed92f18e0bff91621c62baf89288ef70e3e92981";
    x86_64-unknown-linux-musl = "f92a5a4adcfac4206a223d089a364a8375d1b6f112f3f2efa3f6d53d08a61904";
    arm-unknown-linux-gnueabihf = "e5d93576eef874a9b22be9aa157cac5c8cdebebde8b57f0693248d4a589df42c";
    armv7-unknown-linux-gnueabihf = "34ba3c979b144ef27d3c71d177cc1774551edf26e79d36719c86a51d9b9e34c0";
    aarch64-unknown-linux-gnu = "b551bd482041307fa3373a687d6d6a2c4c0931c2e0a68b8b75dc80bc5cf5f002";
    aarch64-unknown-linux-musl = "0a43d96a508c720520328112d609916d062f866a5c35f1db8f906284035d6d98";
    x86_64-apple-darwin = "fe3e248bc4b0ee0a2595693687ad845c8a8bda824a56c9321520bcca02433716";
    powerpc64le-unknown-linux-gnu = "365d7721dd2521e5dad12aa73651bad2be375e798e443636d2c523cad5b54359";
  };

  selectRustPackage = pkgs: pkgs.rust_1_50;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_5" "llvm_11"])
