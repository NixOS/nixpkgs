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
, llvmPackages_16, llvm_16
} @ args:

import ./default.nix {
  rustcVersion = "1.72.0";
  rustcSha256 = "sha256-6p1hu7UddrbqaBFW9p8OBZa1lyLwRBSwHG4QC0tb46E=";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };

  # For use at runtime
  llvmShared = llvm_16.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackages = llvmPackages_16;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.71.1";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "ea544e213cdf65194d9650df9d521dd2ed63251e2abe89c8123e336dfe580b21";
    x86_64-unknown-linux-gnu = "34778d1cda674990dfc0537bc600066046ae9cb5d65a07809f7e7da31d4689c4";
    x86_64-unknown-linux-musl = "67acc1744293e52f4b49231f3c503e8ad187c477e7b567e27925ec792d946a01";
    arm-unknown-linux-gnueabihf = "4c88b32849132504fce5b93bebf06dd0fa17988340c7fe97afa661e038dfa258";
    armv7-unknown-linux-gnueabihf = "8f8556dbd8b0350364c7dc8fda57549934bf3c26c65498dda5842087f5c90d60";
    aarch64-unknown-linux-gnu = "c7cf230c740a62ea1ca6a4304d955c286aea44e3c6fc960b986a8c2eeea4ec3f";
    aarch64-unknown-linux-musl = "da87f4ca2534886f1006b2e8abb0dda8db231ce82cc67b4857233ad48a21c87c";
    x86_64-apple-darwin = "916056603da88336aba68bbeab49711cc8fdb9cfb46a49b04850c0c09761f58c";
    aarch64-apple-darwin = "f4061b65b31ac75b9b5384c1f518e555f3da23f93bcf64dce252461ee65e9351";
    powerpc64le-unknown-linux-gnu = "bac57066882366e4628d1ed2bbe4ab19c0b373aaf45582c2da9f639f2f6ea537";
    riscv64gc-unknown-linux-gnu = "fcb67647b764669f3b4e61235fbdc0eca287229adf9aed8c41ce20ffaad4a3ea";
    mips64el-unknown-linux-gnuabi64 = "6523efea9cd48c0375bd621460d890c65457a5534fafb2d8b69a37ee1e2a39ed";
  };

  selectRustPackage = pkgs: pkgs.rust_1_72;

  rustcPatches = [ ];
}

(builtins.removeAttrs args [ "pkgsBuildTarget" "pkgsBuildHost" "llvmPackages_16" "llvm_16"])
