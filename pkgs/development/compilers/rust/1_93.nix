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
    rustcVersion = "1.93.1";
    rustcSha256 = "sha256-TCMKRLPZyfPO+VCUNxn4OABY0nyR/aXjapqUfvAT4B8=";
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
    bootstrapVersion = "1.93.1";

    # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
    bootstrapHashes = {
      i686-unknown-linux-gnu = "ef2a03ba7b314c32c464f7d1f51053808b270fa46e0334c3962751e63c5a607a";
      x86_64-unknown-linux-gnu = "fa99eb4e823fdeb8ee25e486c7973b4803013ac68c64e8f74880da788db9739c";
      x86_64-unknown-linux-musl = "5a6c766ce05ad7229aadbb365bad2c9c809c9e378706f123c156821fe6ab2711";
      arm-unknown-linux-gnueabihf = "a33bb432cf0ff752a628be3d73670ae053be8675f39414af1f17ada62257449a";
      armv7-unknown-linux-gnueabihf = "0177f471c457b0a29ff81bf99d1078b676d652e6a7ebb31dfbeceb63a274e38c";
      aarch64-unknown-linux-gnu = "bbe822f0aae2c1d31fa950a78446d4749e07ed67e974f87bf0c69146df2a9d9c";
      aarch64-unknown-linux-musl = "859d2e973ba1b0106aaeb5df7db72673cb82b9de417339e28ae9b5074756db5b";
      x86_64-apple-darwin = "5d4bd3705d6cb005449a22aa74ac073886a0e6a6026d2fc24d53b0acaca60255";
      aarch64-apple-darwin = "6bafa3b5367019c576751741295e06717f8f28c9d0e6631dcb9496cd142a386a";
      powerpc64-unknown-linux-gnu = "1b7869988be45153d86703c9ef4c970053b251745ac1571831dcd5f52d512cbf";
      powerpc64le-unknown-linux-gnu = "59dfda4a3ba76113406ce80c802161ec669da49d5b7c0214abc5b99bff633e39";
      powerpc64le-unknown-linux-musl = "2164eec8312e07d5e696cd46c10b5e3bcee06418d9aec47135d81bda2fa0198d";
      riscv64gc-unknown-linux-gnu = "4c2e2697c4911d32bf16dc7361f4205a08aeb557a3843403de1c554cd09ae601";
      s390x-unknown-linux-gnu = "1fafb56fb2d006561d8683c3943d355090bd4350b6692c7643d6f69fee301fd0";
      loongarch64-unknown-linux-gnu = "b0ceb4393dddd0eb3567c4fc7aa4d8b46c21bdb7558289223ffd7336cbaac130";
      loongarch64-unknown-linux-musl = "234fc65d9ae378ce2f55d273cc71841d09d38d6a4c41d873468ed017230d17df";
      x86_64-unknown-freebsd = "61c78738716543c1e217c813bab3ac58d0524afbaeb5fbd40dfdcd3f2c3992a2";
    };

    selectRustPackage = pkgs: pkgs.rust_1_93;
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
