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
  rustcVersion = "1.49.0";
  rustcSha256 = "0yf7kll517398dgqsr7m3gldzj0iwsp3ggzxrayckpqzvylfy2mm";

  llvmSharedForBuild = pkgsBuildBuild.llvm_11.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvm_11.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvm_11.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_5;

  # For use at runtime
  llvmShared = llvm_11.override { enableSharedLibraries = true; };

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.48.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "7fdb8836a1f0427d5b47e6a2d496f67ebff04350407411f57cf20c9b3544e26f";
    x86_64-unknown-linux-gnu = "950420a35b2dd9091f1b93a9ccd5abc026ca7112e667f246b1deb79204e2038b";
    arm-unknown-linux-gnueabihf = "e68a81eebd4570343a0fc35cb8ee24cad911d6cee2e374f284b76546ca6636d5";
    armv7-unknown-linux-gnueabihf = "3aed4a63ebdd57690a31d11afbe95e6407edc224a6769be5694a1ed43bf899cb";
    aarch64-unknown-linux-gnu = "c4769418d8d89f432e4a3a21ad60f99629e4b13bbfc29aef7d9d51c4e8ee8a8a";
    x86_64-apple-darwin = "20e727cad10f43e3abcedb2a80979ae26923038e0e8a855e8a783da255054113";
    powerpc64le-unknown-linux-gnu = "e6457a0214f3b1b04bd5b2618bba7e3826e254216420dede2971b571a1c13bb1";
  };

  selectRustPackage = pkgs: pkgs.rust_1_49;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_5" "llvm_11"])
