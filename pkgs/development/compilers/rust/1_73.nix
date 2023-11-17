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
, targetPackages
, newScope, callPackage
, CoreFoundation, Security, SystemConfiguration
, pkgsBuildTarget, pkgsBuildBuild, pkgsBuildHost
, makeRustPlatform
, llvmPackages_16, llvm_16
} @ args:

import ./default.nix {
  rustcVersion = "1.73.0";
  rustcSha256 = "sha256-ltYubR8tId96yKyzuYgkEfnnxwNhc/fy7enh8faxuzo=";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };

  # For use at runtime
  llvmShared = llvm_16.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackages = llvmPackages_16;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.72.1";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "a2a849a701dfd6643aaaa27e1ed5ac56aea00f7dee26c00d81c520808efd8911";
    x86_64-unknown-linux-gnu = "4fbd8df2000cf73c632d67a219a7fc153537ceffa2e6474491e3db71fdd5a410";
    x86_64-unknown-linux-musl = "94eddc044868a944a887d0b0375e393cb3acc6ebc034e3eac2ef2890ec7c0eac";
    arm-unknown-linux-gnueabihf = "a4d90538882181722d3e7cb8d7f021770e29e6b6d28375452e31a98049600110";
    armv7-unknown-linux-gnueabihf = "4c8e6b3c705a84d17894d3a1cfe744fb6083dd57c61868e67aac8b8512640ecb";
    aarch64-unknown-linux-gnu = "190d0473cbe619f163d33a6c4e2ef982abdd4178f73abc3194631cd2d5c8ed8b";
    aarch64-unknown-linux-musl = "c83778d1a95f6604bc3610a9070e8a8435c60a8bca5117aad71ffab36dea020f";
    x86_64-apple-darwin = "d01e7e9a7482f88a51b4fd888f06234274b49f51b5476c2d14fd46fd6e99ba9e";
    aarch64-apple-darwin = "42b0aaf269b6d9c60db13a64a920336d6064ab11d0c7043c9deeb9d4f67b3983";
    powerpc64le-unknown-linux-gnu = "9310df247efc072f2ca27354a875c4989cf3c29c9e545255a7472895d830163c";
    riscv64gc-unknown-linux-gnu = "1e08cd3ecd29d5bf247e3f7f4bc97318b439f0443dd9c99c36edcfa717d55101";
  };

  selectRustPackage = pkgs: pkgs.rust_1_73;

  rustcPatches = [ ];
}

(builtins.removeAttrs args [ "pkgsBuildTarget" "pkgsBuildHost" "llvmPackages_16" "llvm_16"])
