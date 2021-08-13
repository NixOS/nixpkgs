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
  rustcVersion = "1.54.0";
  rustcSha256 = "0xk9dhfff16caambmwij67zgshd8v9djw6ha0fnnanlv7rii31dc";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_12.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_12.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_12.libllvm.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_11;

  # For use at runtime
  llvmShared = llvm_12.override { enableSharedLibraries = true; };

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.53.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "4ebeeba05448b9484bb2845dba2ff4c0e2b7208fa8b08bef2b2ca3b171d0db99";
    x86_64-unknown-linux-gnu = "5e9e556d2ccce27aa8f01a528f1348bf8cdd34496c35ec2abf131660b9792fed";
    x86_64-unknown-linux-musl = "908b6163b62660f289bcd1eda1a0eb6d849b4b29da12546d24a033e5718e93ff";
    arm-unknown-linux-gnueabihf = "6ae3108f4a0b0478c76f5dbaf1827c9e4a983fa78a9f973b24d501e693cfdcab";
    armv7-unknown-linux-gnueabihf = "886e78f7c5bd92e16322ca3af70d1899c064837343cdfeb9a216b76edfd18157";
    aarch64-unknown-linux-gnu = "cba81d5c3d16deee04098ea18af8636bc7415315a44c9e44734fd669aa778040";
    aarch64-unknown-linux-musl = "a0065a6313bf370f2844af6f3b47fe292360e9cca3da31b5f6cb32db311ba686";
    x86_64-apple-darwin = "940a4488f907b871f9fb1be309086509e4a48efb19303f8b5fe115c6f12abf43";
    aarch64-apple-darwin = "c519da905514c05240a8fe39e459de2c4ef5943535e3655502e8fb756070aee1";
    powerpc64le-unknown-linux-gnu = "9f6c17427d1023b10694e4ba60d6d9deec0aeb07d051f99763789ed18e07e2e6";
    riscv64gc-unknown-linux-gnu = "6ae23ac00269df72b0790f10f2d9a98d03acf542c6090f4d30a87365fafd14ed";
  };

  selectRustPackage = pkgs: pkgs.rust_1_54;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_12" "llvm_12"])
