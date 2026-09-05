# New rust versions should first go to staging.
# Things to check after updating:
# 1. Rustc should produce rust binaries on x86_64-linux, aarch64-linux and x86_64-darwin:
#    i.e. nix-shell -p fd or @GrahamcOfBorg build fd on github
#    This testing can be also done by other volunteers as part of the pull
#    request review, in case platforms cannot be covered.
# 2. The LLVM version used for building should match with rust upstream.
#    Check the version number in the src/llvm-project git submodule in:
#    https://github.com/rust-lang/rust/blob/<version-tag>/.gitmodules

# Note: The way this is structured is:
# 1. Import default.nix, and apply arguments as needed for the file-defined function
# 2. Implicitly, all arguments to this file are applied to the function that is imported.
#    if you want to add an argument to default.nix's top-level function, but not the function
#    it instantiates, add it to the `removeAttrs` call below.
{
  stdenv,
  lib,
  newScope,
  callPackage,
  pkgsBuildTarget,
  pkgsBuildBuild,
  pkgsBuildHost,
  pkgsHostTarget,
  pkgsTargetTarget,
  makeRustPlatform,
  wrapRustcWith,
  llvmPackages,
  llvm,
  cargo-auditable,
  wrapCCWith,
  overrideCC,
  fetchpatch,
}@args:
let
  llvmSharedFor =
    pkgSet:
    pkgSet.llvmPackages.libllvm.override (
      {
        enableSharedLibraries = true;
      }
      // lib.optionalAttrs (stdenv.targetPlatform.useLLVM or false) {
        # Force LLVM to compile using clang + LLVM libs when targeting pkgsLLVM
        stdenv = pkgSet.stdenv.override {
          allowedRequisites = null;
          cc = pkgSet.pkgsBuildHost.llvmPackages.clangUseLLVM;
        };
      }
    );
in
import ./default.nix
  {
    rustcVersion = "1.98.0";
    rustcSha256 = "sha256-siau83X/vp++K4X96Za1BxbVnVUmjiQNBSOWU0t16Sk=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    inherit llvmPackages cargo-auditable;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.98.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "2706508ca1bc0e2a1205b761d6044d0185bbe322d437225a6c6b74fa917616ab";
      x86_64-unknown-linux-gnu = "aa30409afa67bd1ada244cefd82c7980e6a65bc113bb978e934b2413c75e3900";
      x86_64-unknown-linux-musl = "b2cf07e41d4747ddf3b20962ca9de2a08da00646f55ab4c1b51cef99895bae0a";
      arm-unknown-linux-gnueabihf = "9fcdd10e5855ea8c7af75d5b709f7125e06b0dd653e14235503d5ef885a7350d";
      armv7-unknown-linux-gnueabihf = "fe4b4ad389108c8b90ae77ed66b62073468a77892483bc11d2be570b64b866db";
      aarch64-unknown-linux-gnu = "5fbb4282403046d52a4672765c6761a809bf9f33e699b17e6eb7a93ab7770cc3";
      aarch64-unknown-linux-musl = "c26e37bb6f20e49498c552e53e3f34871ba2f7610c7f8b2cce38a48e3570c7de";
      x86_64-apple-darwin = "66f4e2e17275753deaba8437380de21072b56b5a083cf954bacb6376df0834fc";
      aarch64-apple-darwin = "026ec75bec81fb8c10b11df98f1336ee39f4bc11e04d6745dffe9fca81e5c0b5";
      powerpc64-unknown-linux-gnu = "7ed997cfa306e503362129334e58aebe3b2db9bf2b75a96803636d4098db9ca7";
      powerpc64le-unknown-linux-gnu = "c20df5c7133492efc4a5e66f9a41aef3dcb50d2a0d8acef98e635ab1c3e49fdb";
      powerpc64le-unknown-linux-musl = "278b9d213ea3c28e4191bd068ef9d4c722548f775abee90b9d06aefcce6d74f8";
      riscv64gc-unknown-linux-gnu = "64757537fada45bb7c203ec0d77fda72a11f5d24cf9dcab84cc4168256858a0c";
      s390x-unknown-linux-gnu = "0c698f9ef09c91e3694149e0f090c8d7ef58d443f89d6dae41c6ca481cc6ec5e";
      loongarch64-unknown-linux-gnu = "f01c72bff960ae872eb2b809c6243f7b9adf57c7257eb53293f8fe71f526be6e";
      loongarch64-unknown-linux-musl = "8690a377e5a54b9b42c0f8e35b13c8e22686587995522469a248cbfe326c2bbf";
      x86_64-unknown-freebsd = "c8d2765c9a3a599c8e475ac8b5b448ac9e2d64a891b6014ce5c07dbfc23ce36c";
    };

    selectRustPackage = pkgs: pkgs.rust_1_98;
  }

  (
    removeAttrs args [
      "llvmPackages"
      "llvm"
      "wrapCCWith"
      "overrideCC"
      "pkgsHostTarget"
      "fetchpatch"
      "cargo-auditable"
    ]
  )
