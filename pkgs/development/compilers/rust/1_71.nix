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
  rustcVersion = "1.71.1";
  rustcSha256 = "sha256-b6kNUNHVKadfbMNJeE3lfX7AuiQZsJvefTNcJb1ORy4=";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_16.libllvm.override { enableSharedLibraries = true; };

  # For use at runtime
  llvmShared = llvm_16.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackages = llvmPackages_16;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.70.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "119dfd4ee3da6c8fc36444dd15a12187e1f9b34ee6792fb75a6a25d09ea7e865";
    x86_64-unknown-linux-gnu = "8499c0b034dd881cd9a880c44021632422a28dc23d7a81ca0a97b04652245982";
    x86_64-unknown-linux-musl = "d97c2ac1d9f17e754fa6b7d48c28531d16278547e3fa47050a01da037ddb6de3";
    arm-unknown-linux-gnueabihf = "ac98b513c31789d0c3201dfe2bbcc81b9437f7e1a15695d09402efec7934c20e";
    armv7-unknown-linux-gnueabihf = "23e6029c2a7363b307af539f0c81f4bb9f0ade12b588658343c8a8cfa41526ae";
    aarch64-unknown-linux-gnu = "3aa012fc4d9d5f17ca30af41f87e1c2aacdac46b51adc5213e7614797c6fd24c";
    aarch64-unknown-linux-musl = "6381de0b55f1741ac322bf1b56701d8aab4e509ff5302043941170f8df34228e";
    x86_64-apple-darwin = "e5819fdbfc7f1a4d5d82cb4c3b7662250748450b45a585433bfb75648bc45547";
    aarch64-apple-darwin = "75cbc356a06c9b2daf6b9249febda0f0c46df2a427f7cc8467c7edbd44636e53";
    powerpc64le-unknown-linux-gnu = "ba8cb5e3078b1bc7c6b27ab53cfa3af14001728db9a047d0bdf29b8f05a4db34";
    riscv64gc-unknown-linux-gnu = "5964f78e5fb30506101a929162a42be6260b887660b71592c5f38466753440c3";
    mips64el-unknown-linux-gnuabi64 = "de5fd0b249fbb95b9b67928ba08d7ec49f18f0ae25cbe1b0ede3c02390d7b93a";
  };

  selectRustPackage = pkgs: pkgs.rust_1_71;

  rustcPatches = [ ];
}

(builtins.removeAttrs args [ "pkgsBuildTarget" "pkgsBuildBuild" "pkgsBuildHost" "llvmPackages_16" "llvm_16"])
