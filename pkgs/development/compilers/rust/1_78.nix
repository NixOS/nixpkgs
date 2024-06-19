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
, newScope, callPackage
, CoreFoundation, Security, SystemConfiguration
, pkgsBuildTarget, pkgsBuildBuild, pkgsBuildHost, pkgsTargetTarget
, makeRustPlatform
, wrapRustcWith
, llvmPackages_18, llvm_18
} @ args:

import ./default.nix {
  rustcVersion = "1.78.0";
  rustcSha256 = "/1RII6XLJ/JzgShXfx5+AO6PTIPyo0h4GuT8NV6R1ak=";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_18.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_18.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_18.libllvm.override { enableSharedLibraries = true; };

  # For use at runtime
  llvmShared = llvm_18.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackages = llvmPackages_18;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.77.2";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "168e653fbc30b3a80801bc7735a79ff644651618434234959925f669bf77d1a2";
    x86_64-unknown-linux-gnu = "b7d12b1b162c36c1fd5234b4b16856aa7eafca91d17c49787f6487cb26f4062d";
    x86_64-unknown-linux-musl = "2e08fe23c4837a780a40ebfac601760cd6297581d21eae2f88cb59060243a375";
    arm-unknown-linux-gnueabihf = "9f14a31dbef0153c0a7463a79cf8f9e8295b355354de41aa054953027beb70d7";
    armv7-unknown-linux-gnueabihf = "b37649399081228244b3ff3acc6047f6c138e602c721cd500efe43715d043c5e";
    aarch64-unknown-linux-gnu = "297c6201edd42e580f242fcd75b521b0392f6f3be02cf03ca76690fece4a74da";
    aarch64-unknown-linux-musl = "fdd9c485f93c73a085c113b4f0fbad0989f79153079d394ec4bbac2b3804f71b";
    x86_64-apple-darwin = "16bbbfcf0c982b35271d8904977d80fda1bb7caa7f898abceed3569a867d9cea";
    aarch64-apple-darwin = "415bb2bc198feb0f2d8329e33c57d0890bbd57977d1ae48b17f6c7e1f632eaa7";
    powerpc64le-unknown-linux-gnu = "79582acb339bd2d79fef095b977049049ffa04616011f1af1793fb8e98194b19";
    riscv64gc-unknown-linux-gnu = "300fe4861e2d1f6e4c4f5e36ae7997beca8a979343a7f661237ab78a37a54648";
  };

  selectRustPackage = pkgs: pkgs.rust_1_78;

  rustcPatches = [ ];
}

(builtins.removeAttrs args [ "llvmPackages_18" "llvm_18"])
