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
, llvmPackages_13, llvm_13
} @ args:

import ./default.nix {
  rustcVersion = "1.59.0";
  rustcSha256 = "sha256-p8juruhb/O+EyWsCsxcdHmVA0VF5/4Pd3Z6vuhhfhfk=";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_13.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_13.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_13.libllvm.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_11;

  # For use at runtime
  llvmShared = llvm_13.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackagesForBuild = pkgsBuildBuild.llvmPackages_13;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.58.1";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "c3d282cd96cc9e5292e62db1ebb9fa6d5b738f4684d5ece9883f7472e2f76ad4";
    x86_64-unknown-linux-gnu = "4fac6df9ea49447682c333e57945bebf4f9f45ec7b08849e507a64b2ccd5f8fb";
    x86_64-unknown-linux-musl = "7036e34eadc8ce22d16b0625919d9f2244ca49a5441d6599f4822116c181d272";
    arm-unknown-linux-gnueabihf = "739389d46c5862b0e67d01dece99aa3db2229e055a3d7f7624679c55b6c33e06";
    armv7-unknown-linux-gnueabihf = "6cede2c7795e8126b0f17b1032d52500e594bac64c7d190bdc0ac1c832ef30bd";
    aarch64-unknown-linux-gnu = "ce557516593e4526709b0f33c2e1d7c932b3ddf76af94c2417d8d667921ce90c";
    aarch64-unknown-linux-musl = "b1533fdeeda483a3633617fd18a79d8fad7821331614b8dc13efd8b22acc30f5";
    x86_64-apple-darwin = "d0044680fc132a721481b130a0a4282a444867f423efdb890fe13e447966412f";
    aarch64-apple-darwin = "00b44985bc87e53c53d92622fb10226f09e9f25c79db48a77c0a769a36f83b1e";
    powerpc64le-unknown-linux-gnu = "b15baef702cbd6f0ea2bef7bf98ca7ce5644f2beb219028e8a12e7053da4c849";
    riscv64gc-unknown-linux-gnu = "d8ea2b11a4b24d1169fa3190127488b951b8bdef28293a4129ddd46c0ba9469b";
    mips64el-unknown-linux-gnuabi64 = "4f03bc972ae784d4f66cfa77215b369723531e67f647de9f49ce9fc21e5691af";
  };

  selectRustPackage = pkgs: pkgs.rust_1_59;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_13" "llvm_13"])
