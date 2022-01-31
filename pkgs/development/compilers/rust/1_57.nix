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
  rustcVersion = "1.57.0";
  rustcSha256 = "06jw8ka2p3kls8p0gd4p0chhhb1ia1mlvj96zn78n7qvp71zjiim";

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
  bootstrapVersion = "1.56.1";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "84db34603ce22d93312ff8bccd5580fe112e932bbeb0361e7cc37668a9803a27";
    x86_64-unknown-linux-gnu = "a6be5d045183a0b12dddf0d81633e2a64e63e4c2dfa44eb7593970c1ef93a98f";
    x86_64-unknown-linux-musl = "3c09058d104d9a88943fb343af1fb70422f9c4a987e6703666ee8a8051211190";
    arm-unknown-linux-gnueabihf = "c445706d109bb74de4c889687ae08a48af5808676fda15b84b7ef5970a82a5f6";
    armv7-unknown-linux-gnueabihf = "29ec65af502370c0c1a49faecd7131f1243fe3005b419ead4b40b267af2b2db0";
    aarch64-unknown-linux-gnu = "69792887357c8dd78c5424f0b4a624578296796d99edf6c30ebe2acc2b939aa3";
    aarch64-unknown-linux-musl = "971d13d41657e50e3ac54f17f52b4198c3d8bc25ec489a6a9e6d12c18226dda5";
    x86_64-apple-darwin = "8d65ef02a123c23be00101fb204d28b60498b9145dd2ee8edabf0afde6e01e55";
    aarch64-apple-darwin = "e71c14c1368048a22e4d1851f301872ac2e6f4c574f04d2a7ae4d64b0e7c7235";
    powerpc64le-unknown-linux-gnu = "fa78b28fe1ef3cd4add9ec151e5eab756dfc83c8bc3e5a576a6eddd350c4de7a";
    riscv64gc-unknown-linux-gnu = "5ec327d1bd3ba8d00afbe9be4a1f0fb8ab845063fcf9be479be9493c52a4dbb6";
  };

  selectRustPackage = pkgs: pkgs.rust_1_57;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_13" "llvm_13"])
