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
    rustcVersion = "1.97.0";
    rustcSha256 = "sha256-HAhV2JgqD7HQMhtgVLVbcy07HRfIRoQet/0Ks3vydvg=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    inherit llvmPackages cargo-auditable;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.97.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "d066e5dd59c15fc1c793173d53b41719162de4470b5c34041a8bc664542df375";
      x86_64-unknown-linux-gnu = "eb89b20287153391c49ebcdb7fd91b683a12438d129bfb92eadcc495545af3a7";
      x86_64-unknown-linux-musl = "675bb2d574efc64da0563a9cb70cc017560394c5938e04c92987cad383299e8d";
      arm-unknown-linux-gnueabihf = "180e487a1f7abaeda374b942d369dd7faa4364b1267629d48552d9a17a5bc4ab";
      armv7-unknown-linux-gnueabihf = "2f9dfd76694efcf391f6d4947e97be17d1f469c9e989ed194660ddd85877ca60";
      aarch64-unknown-linux-gnu = "70fb01b4894d56fad34c260ce63aee647589be57a26ab33730110d8228cbcf02";
      aarch64-unknown-linux-musl = "28efcf4ee31235eb5f7820dadba46400ab9dbbb030719e7a2ab284b02c8cbf82";
      x86_64-apple-darwin = "3dc9ad8ec35a9f0acd2c5ae2c80c36baf5c7010423bf339ca55709fc995885d4";
      aarch64-apple-darwin = "c2e6a5ef480f5715ae9874188c1fa749b6a6f90d8d911f5a3a5d768f0ac70427";
      powerpc64-unknown-linux-gnu = "62c9f9b7887505fc4dcda40784469f23909657d245e53025a7a8124b016d6631";
      powerpc64le-unknown-linux-gnu = "a8d3f487d07cebc48ce03ad66a970a5f5138a5c1e7c7cec12fb9b6e47a24bf1a";
      powerpc64le-unknown-linux-musl = "09fee3b9ede1e94ff6c3bad3918dc231be909c74bb182e0acd583c03a9f1df5f";
      riscv64gc-unknown-linux-gnu = "be239392f7112f6a81f20c9e715d5743319a8b773592e027ad800d73527d8fae";
      s390x-unknown-linux-gnu = "fee699e31d0a0034f46669c473e61a88af6734f8c5902d77329ac236fcd9b538";
      loongarch64-unknown-linux-gnu = "37ad9d55b98cc680a2d75c7184e6457b632ce82690a56be7a2044e32c91176ce";
      loongarch64-unknown-linux-musl = "bfba202bae252ac372026171d9bc98e5eb80578d576546f56e8aee2e9d64ecf0";
      x86_64-unknown-freebsd = "77101232e3769395e99c0e663d2c8beb3d4127857945cf7c812c1886ba823b8f";
    };

    selectRustPackage = pkgs: pkgs.rust;
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
