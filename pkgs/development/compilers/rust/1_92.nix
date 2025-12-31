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
    rustcVersion = "1.92.0";
    rustcSha256 = "sha256-ng0sp1x+J1/cdYJVv0sDr7PWXRVDYCdGkHyTO2kBw7g=";
    rustcPatches = [ ./ignore-missing-docs.patch ];

    llvmSharedForBuild = llvmSharedFor pkgsBuildBuild;
    llvmSharedForHost = llvmSharedFor pkgsBuildHost;
    llvmSharedForTarget = llvmSharedFor pkgsBuildTarget;

    inherit llvmPackages cargo-auditable;

    # For use at runtime
    llvmShared = llvmSharedFor pkgsHostTarget;

    # Note: the version MUST be the same version that we are building. Upstream
    # ensures that each released compiler can compile itself:
    # https://github.com/NixOS/nixpkgs/pull/351028#issuecomment-2438244363
    bootstrapVersion = "1.92.0";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "0028378e76fc10255677a5398886664f619c15757f3e830d7464f3c716bc3f7e";
      x86_64-unknown-linux-gnu = "6e5efd6c25953b2732d4e6b1842512536650c68cf72a8b99a0fc566012dd6ca5";
      x86_64-unknown-linux-musl = "1a257be51efac7bea14d5566e521777b85c473ee42524a38abb181c6443c38e4";
      arm-unknown-linux-gnueabihf = "e8d400cc169f858915f8c5bd23070d5b7f63ca8b1d14a5ef53423d952e33a794";
      armv7-unknown-linux-gnueabihf = "1c0f84532a91f3ce7223613565f15f8992a8e09859d699c163a7782d15d6beef";
      aarch64-unknown-linux-gnu = "c812028423c3d7dd7ba99f66101e9e1aa3f66eab44a1285f41c363825d49dca4";
      aarch64-unknown-linux-musl = "ad412daf7b31aadbeb12f836ed14983f5d1d0717bd444e305f94ee68ea822fcd";
      x86_64-apple-darwin = "fc6868991e61e9262272effbb8956b23428430f5f4300c1b48eaae3969f8af2a";
      aarch64-apple-darwin = "235a6cca2dd4881130a9ae61ad1149bbf28bba184dd4621700f0c98c97457716";
      powerpc64-unknown-linux-gnu = "189dd8a254202d32066f123b42497b88f809a11680842e67c68e48a4200b6caf";
      powerpc64le-unknown-linux-gnu = "e2fe00a3c91f21c52947ebf96b4da016c9def5ccfedd1c335f30746db58bbf35";
      powerpc64le-unknown-linux-musl = "4655468ef2ccc3d6eaf55015054970ab4a8fb79d853add830c9e4016551b7101";
      riscv64gc-unknown-linux-gnu = "c2d1b80d3c69edcca5c0d2b2042fad43fdb06fa614a8cd09063c1c259dca8a7e";
      s390x-unknown-linux-gnu = "1ca05b6bd892c358ae0a12acbb605560529d80633abebb43ec004142205d7bd2";
      loongarch64-unknown-linux-gnu = "2f9a85ff1816d6e28a96c1f5b9c9c5d9fe710a20a36f172c41bc289cc780956e";
      loongarch64-unknown-linux-musl = "4fe07780b1ac08baee71de2ddbd275ba14cc082df54ea5a95055514130152546";
      x86_64-unknown-freebsd = "f32b7d8d5ad5c186fa496dd0b7202899f89e93870940e41c37e576f324494189";
    };

    selectRustPackage = pkgs: pkgs.rust_1_92;
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
