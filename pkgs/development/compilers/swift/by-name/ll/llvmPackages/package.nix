# Swift needs to be built against the matching tag from the LLVM fork in the swiftlang repo.
# Ideally, it would build against upstream LLVM, but it depends on APIs that have not been upstreamed.
# For example: https://github.com/swiftlang/llvm-project/blob/901f89886dcd5d1eaf07c8504d58c90f37b0cfdf/clang/include/clang/AST/StableHash.h

{
  lib,
  apple-sdk_26,
  darwin,
  fetchFromGitHub,
  generateSplicesForMkScope,
  libuuid,
  lld,
  llvmPackages_19, # Needs to match the `llvmVersion` of the fork.
  python3,
  stdenv,
  stdlib,
  swift-cmark,
  swiftc,
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
    "swiftPackages"
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

      lldb =
        let
          python3-with-distutils = python3.withPackages (pkgs: [ pkgs.distutils ]);

          swiftLLDB = prev.lldb.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              # The LLDB build on Linux assumes the rpath is set relative to the toolchain and that `SWIFT_LIBRARY_DIR`
              # consists of only one path (and is not a list). It needs to point to the stdlib.
              ./patches/lldb/0001-Set-stdlib-path-on-Linux.patch
              # Otherwise, linking `lldb-server` fails with a missing symbol error on Linux.
              ./patches/lldb/0002-Link-lldb-server-to-swiftCore.patch
              # Don’t resolve the liblldb symlink to help it find the Swift toolchain that it’s linked into.
              ./patches/lldb/0003-Don-t-follow-symlinks-when-finding-liblldb.patch
            ];
            buildInputs =
              (old.buildInputs or [ ])
              ++ [
                stdlib # The LLDB build system expects the stdlib libraries to be available on the default linker path.
              ]
              # For `swift_coroFrameAlloc`, which needs an SDK with libswiftCore text-based stubs that have the symbol.
              ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_26 ];
            # Swift’s fork of LLDB has extra requirements.
            nativeBuildInputs =
              (old.nativeBuildInputs or [ ])
              ++ [
                python3-with-distutils # distutils is needed for the bundled Python plugin.
              ]
              ++ lib.optionals stdenv.hostPlatform.isDarwin [
                darwin.sigtool # Required for code-signing.
                lld # Otherwise results in `can't find ordinal for imported symbol '_objc_opt_self'` when linking.
              ];
            # These aren’t set correctly otherwise. The LLDB build system needs an explicit Swift path regardless.
            cmakeFlags =
              (old.cmakeFlags or [ ])
              ++ [
                (lib.cmakeFeature "Clang_DIR" "${lib.getDev final.libclang}/lib/cmake/clang")
                (lib.cmakeFeature "LLVM_DIR" "${lib.getDev final.libllvm}/lib/cmake/llvm")
                (lib.cmakeFeature "Swift_DIR" "${lib.getOutput "static" swiftc}")
                (lib.cmakeFeature "cmark-gfm_DIR" "${swift-cmark.out}/lib/cmake")
                (lib.cmakeFeature "LLDB_SWIFT_LIBS" "${lib.getDev stdlib}/lib/swift")
              ]
              ++ lib.optionals stdenv.hostPlatform.isDarwin [
                (lib.cmakeFeature "CMAKE_LINKER_TYPE" "LLD") # Darwin fails to link correctly using ld64 (see above).
              ];

            # Make sure LLDB can find the Swift compiler shared libraries.
            postInstall =
              (old.postInstall or "")
              + lib.optionalString stdenv.hostPlatform.isElf ''
                for output in $(getAllOutputNames); do
                  while IFS= read -d "" f; do
                    if isELF "$f"; then
                      # Make sure all rpaths are present. Why is libuuid getting dropped? I have no idea.
                      patchelf --add-rpath ${
                        lib.escapeShellArg (lib.makeSearchPathOutput "out" "lib/swift/host/compiler" [ swiftc ])
                      } "$f" || true
                      patchelf --add-rpath ${lib.escapeShellArg (lib.makeLibraryPath [ libuuid ])} "$f" || true
                    fi
                  done < <(find "''${!output}" -type f -print0)
                done
              '';
          });
        in
        # Linux tries to use a GCC stdenv to build LLDB, but the Swift headers aren’t compatible with GCC.
        # The stdenv passed in from the package set arguments is the Clang-based stdenv from `swift-packages.nix`.
        swiftLLDB.override { inherit stdenv; };

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
