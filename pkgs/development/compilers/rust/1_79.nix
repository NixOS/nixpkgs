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
let
  llvmSharedFor = pkgSet: pkgSet.llvmPackages_18.libllvm.override ({
    enableSharedLibraries = true;
  } // lib.optionalAttrs (stdenv.targetPlatform.useLLVM or false) {
    # Force LLVM to compile using clang + LLVM libs when targeting pkgsLLVM
    stdenv = pkgSet.stdenv.override { allowedRequisites = null; cc = pkgSet.llvmPackages_18.clangUseLLVM; };
  });
in
import ./default.nix {
  rustcVersion = "1.79.0";
  rustcSha256 = "sha256-Fy7PPH0fnZ+xbNKmKIaXgmcEFt7QEp5SSoZ1H5YUSMA=";

  llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
  llvmSharedForHost = llvmSharedFor pkgsBuildHost;
  llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

  # For use at runtime
  llvmShared = llvmSharedFor { inherit llvmPackages_18 stdenv; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackages = if (stdenv.targetPlatform.useLLVM or false) then (let
    setStdenv = pkg: pkg.override {
      stdenv = stdenv.override { allowedRequisites = null; cc = llvmPackages_18.clangUseLLVM; };
    };
  in rec {
    libunwind = setStdenv llvmPackages_18.libunwind;
    llvm = setStdenv llvmPackages_18.llvm;

    libcxx = llvmPackages_18.libcxx.override {
      stdenv = stdenv.override {
        allowedRequisites = null;
        cc = llvmPackages_18.clangNoLibcxx;
        hostPlatform = stdenv.hostPlatform // {
          useLLVM = !stdenv.isDarwin;
        };
      };
      inherit libunwind;
    };
  }) else llvmPackages_18;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.78.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "8f3f5d2ab7b609ab30d584cfb5cecc3d8b16d2620fffb7643383c8a0a3881e21";
    x86_64-unknown-linux-gnu = "1307747915e8bd925f4d5396ab2ae3d8d9c7fad564afbc358c081683d0f22e87";
    x86_64-unknown-linux-musl = "c11ab908cbffbe98097d99ed62f5db00aa98496520b1e09583a151d36df7fca4";
    arm-unknown-linux-gnueabihf = "2a2b1cf93b31e429624380e5b0d2bcce327274f8593b63657b863e38831f6421";
    armv7-unknown-linux-gnueabihf = "fcce5ddb4f55bbdc9a1359a4cb6e65f2ff790d59ad228102cd472112ea65d3fe";
    aarch64-unknown-linux-gnu = "131eda738cd977fff2c912e5838e8e9b9c260ecddc1247c0fe5473bf09c594af";
    aarch64-unknown-linux-musl = "f328bcf109bf3eae01559b53939a9afbdb70ef30429f95109f7ea21030d60dfa";
    x86_64-apple-darwin = "6c91ed3bd90253961fcb4a2991b8b22e042e2aaa9aba9f389f1e17008171d898";
    aarch64-apple-darwin = "3be74c31ee8dc4f1d49e2f2888228de374138eaeca1876d0c1b1a61df6023b3b";
    powerpc64le-unknown-linux-gnu = "c5aedb12c552daa18072e386697205fb7b91cef1e8791fe6fb74834723851388";
    riscv64gc-unknown-linux-gnu = "847a925ace172d4c0a8d3da8d755b8678071ef73e659886128a3103bb896dcd9";
    x86_64-unknown-freebsd = "b9cc84c60deb8da08a6c876426f8721758f4c7e7c553b4554385752ad37c63df";
  };

  selectRustPackage = pkgs: pkgs.rust_1_79;

  rustcPatches = [ ];
}

(builtins.removeAttrs args [ "llvmPackages_18" "llvm_18"])
