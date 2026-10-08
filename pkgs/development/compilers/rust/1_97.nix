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
    rustcVersion = "1.97.1";
    rustcSha256 = "sha256-YiwrQpxTy/3A3TpR0DVU6RzWPr7BkSwfVwlkDN/vGp0=";

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    inherit llvmPackages cargo-auditable;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.97.1";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "914c2702deada0b9cf1d64bb3495d76e55cb3eba07d508472dde8b55a93e3759";
      x86_64-unknown-linux-gnu = "b4cdbc7cc6b0ee0a2666b1872769fdb2ad8393b28b63952f6493b4b400e4832b";
      x86_64-unknown-linux-musl = "40dbea28193cf2b488cf3e4a89274ccfb60efa50883f19917a382f84fd05bdc4";
      arm-unknown-linux-gnueabihf = "ba62fe07ad85b507907705a14adc1e8bc258de5f6177ba41d77bbff9f469a4ce";
      armv7-unknown-linux-gnueabihf = "e89c5e33aaddc6ef56857000c9117875c2997e9a1a500bd7b16277c9874b002f";
      aarch64-unknown-linux-gnu = "2f2496c70bd336a66a4c8baf2d303ba161f3552f192444c3639ba903c7c1e2c5";
      aarch64-unknown-linux-musl = "c5f45b5c6eb7f8fdb277c54c08402b7c931516740fbd4eccc26ba148f7cd5d57";
      x86_64-apple-darwin = "5f4c84d2bcce7983468642855a45fc4978fba1324cfdd1ea0b182face3ab4ffa";
      aarch64-apple-darwin = "cbd14c36f039f6f11f38148a6295d8234d18ddf20bea53031c86f119423a8b26";
      powerpc64-unknown-linux-gnu = "2b507d5eb9b5c4c041b50e93e069db56d094f02e6df103dc74c016155141bfae";
      powerpc64le-unknown-linux-gnu = "ff524eef5a59d801df09ccad5cdaf9ea1f0a07d75cbed2a7e9f013a9eb76a3c1";
      powerpc64le-unknown-linux-musl = "15630f33fbea2dd9661f8482b6c612da271549aba40401444aaa53650e646b9b";
      riscv64gc-unknown-linux-gnu = "59bec35d8febb2ab918fa41cffbaa5b07146a63bdc33f029ff756d70a3151ece";
      s390x-unknown-linux-gnu = "808268af9e880d41b8cb32b242e38c9bd3ea7aba6409b02fbffa0fbc5370c538";
      loongarch64-unknown-linux-gnu = "d5a925962854730ae7641420d8337af93988ea4ff47b503a856ec53776c87841";
      loongarch64-unknown-linux-musl = "3fb653299d228e3e0726afb179b07dd10a51a2ecc3cdfcd740011b1d8420ca97";
      x86_64-unknown-freebsd = "77866a4c449bcccb40e9d6712bf3eb899d29018ed8e841fd9d8d59370751f152";
    };

    selectRustPackage = pkgs: pkgs.rust_1_97;
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
