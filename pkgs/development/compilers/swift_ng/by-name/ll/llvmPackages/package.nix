# Swift needs to be built against the matching tag from the LLVM fork in the swiftlang repo.
# Ideally, it would build against upstream LLVM, but it depends on APIs that have not been upstreamed.
# For example: https://github.com/swiftlang/llvm-project/blob/901f89886dcd5d1eaf07c8504d58c90f37b0cfdf/clang/include/clang/AST/StableHash.h

{
  lib,
  fetchFromGitHub,
  generateSplicesForMkScope,
  llvmPackages_19, # Needs to match the `llvmVersion` of the fork.
  swift_release,
  swift_sources,
}:

let
  swiftLlvmVersion = "17.0.0"; # From https://github.com/swiftlang/swift/blob/swift-$swiftVersion-RELEASE/utils/build_swift/build_swift/defaults.py#L51
  llvmVersion = "19.1.5"; # From https://github.com/swiftlang/llvm-project/blob/swift-$swiftVersion-RELEASE/cmake/Modules/LLVMVersion.cmake
in

(llvmPackages_19.override {
  officialRelease.version = llvmVersion;

  monorepoSrc = fetchFromGitHub {
    owner = "swiftlang";
    repo = "llvm-project";
    tag = "swift-${swift_release}-RELEASE";
    inherit (swift_sources.llvm-project) hash;
  };

  otherSplices = generateSplicesForMkScope [
    "swiftPackages_ng"
    "llvmPackages"
  ];

  patchesFn =
    patches:
    patches
    // {
      # Updated patch that also prevents Clang from trying to copy `clang-deps-launcher.py` to `${llvm}/bin`.
      "clang/gnu-install-dirs.patch" = [ { path = ./patches; } ];
      # Update backport of the Darwin triple changes for macOS 27.
      "llvm/backport-darwin-triple-parsing.patch" = [ { path = ./patches; } ];
    };
}).overrideScope
  (
    final: prev: {
      version = swiftLlvmVersion;
      release_version = llvmVersion;

      libclang = prev.libclang.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          moveToOutput bin/clang-deps-launcher.py "$python"
        '';
      });

      libllvm =
        let
          # The Swift build system expects to link statically against LLVM. Trying to link to the `libLLVM` shared
          # library causes `swift-frontend` to crash during the build on Linux.
          staticLibllvm = prev.libllvm.override { enableSharedLibraries = false; };
        in
        staticLibllvm.overrideAttrs (
          old:
          # Don’t apply the following changes when manpages are built,
          # which nulls out these attrs and sets `doCheck` to false.
          lib.optionalAttrs (old.pname != "llvm-manpages") {
            patches = (old.patches or [ ]) ++ [
              # Ensure the LLVM module cache is in a writable location during builds.
              ./patches/llvm/module-cache.patch
            ];
            doCheck = false; # TODO: fix fork-specific tests that fail due to, e.g., not finding `libLLVM.dylib` during the test
            postInstall = (old.postInstall or [ ]) + ''
              # Swift relies on LLVM’s private `config.h` for feature checks (e.g., for `unistd.h`).
              cp include/llvm/Config/config.h "$dev/include/llvm/Config/config.h"
            '';
          }
        );
    }
  )
