{
  lib,
  apple-sdk_14,
  apple-sdk_26,
  llvmPackages_upstream,
  stdenv,
  swift-corelibs-foundation,
  swift-corelibs-libdispatch,
  swift-foundation,
  swift-foundation-icu,
  swiftc,
  symlinkJoin,
  swift_release,
}:

let
  # Need to use an older SDK if `swiftc` does not support macros.
  propagated-sdk = if swiftc.supportsMacros then apple-sdk_26 else apple-sdk_14;

  # The toolchain needs to propagate libdispatch with and without the Swift overlay to make sure it propagates
  # both the non-Swift shared libraries and the Swift overlay shared library.
  swift-corelibs-libdispatch-no-overlay = swift-corelibs-libdispatch.override { useSwift = false; };

  # `out` and `dev` are merged because that’s what Swift expects.
  outLinks = symlinkJoin {
    name = "swift" + lib.removePrefix "swiftc" (lib.getName swiftc) + "-${swift_release}-out";
    paths = [
      swiftc.out
      swiftc.dev
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && swift-foundation != null) [
      # Needed for FoundationMacros, which is otherwise not part of the SDK on Darwin.
      swift-foundation.out
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) (
      lib.optionals (swift-corelibs-libdispatch != null) [
        swift-corelibs-libdispatch.out
        swift-corelibs-libdispatch.dev
        swift-corelibs-libdispatch-no-overlay.out
        swift-corelibs-libdispatch-no-overlay.dev
      ]
      ++ lib.optionals (swift-foundation != null) [
        swift-corelibs-foundation.out
        swift-corelibs-foundation.dev
        swift-foundation-icu.out
        swift-foundation.dev
        swift-foundation.out
      ]
    );
  };

  docLinks = symlinkJoin {
    name = "swift" + lib.removePrefix "swiftc" (lib.getName swiftc) + "-${swift_release}-doc";
    paths = [
      swiftc.doc
    ];
  };

  manLinks = symlinkJoin {
    name = "swift" + lib.removePrefix "swiftc" (lib.getName swiftc) + "-${swift_release}-man";
    paths = [
      swiftc.man
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin && swift-corelibs-libdispatch != null) [
      swift-corelibs-libdispatch.man
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "swift" + lib.removePrefix "swiftc" (lib.getName swiftc);
  version = swift_release;

  outputs = [
    "out"
    "doc"
    "man"
  ];

  strictDeps = true;

  # Will effectively be `buildInputs` when swift is put in `nativeBuildInputs`.
  depsTargetTargetPropagated =
    lib.optionals stdenv.targetPlatform.isDarwin [ propagated-sdk ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) (
      lib.optionals (swift-corelibs-libdispatch != null) [
        swift-corelibs-libdispatch-no-overlay.out
        swift-corelibs-libdispatch.out
      ]
      ++ lib.optionals (swift-foundation != null) [
        swift-corelibs-foundation.out
        swift-foundation-icu.out
        swift-foundation.out
      ]
    );

  buildCommand = ''
    mkdir -p "$out" "$doc" "$man"

    cp -r ${lib.escapeShellArg outLinks}/* "$out"
    cp -r ${lib.escapeShellArg docLinks}/* "$doc"
    cp -r ${lib.escapeShellArg manLinks}/* "$man"

    # Make writable temporarily to allow for the fixups below to be made to the outputs.
    chmod -R u+w "$out/bin" "$out/lib" "$out/nix-support"

    # Swift expects to find Clang next to it.
    ln -s ${lib.escapeShellArg (lib.getExe' llvmPackages_upstream.clang "clang")} "$out/bin/clang"

    # `swift-frontend` expects to find everything relative to its location after resolving symlinks.
    # Also copy `swift-driver` assuming it does similar.
    for exe in swift-driver swift-frontend; do
      if [ -e "$out/bin/$exe" ]; then
        orig=$(readlink "$out/bin/$exe")
        rm "$out/bin/$exe"
        cp "$orig" "$out/bin/$exe"
      fi
    done

    # Propagated inputs in `$dev/nix-support` have to be substituted to use this derivation instead of swiftc.
    for f in "$out/nix-support/"*; do
      orig=$(readlink "$f")
      rm "$f"
      substitute "$orig" "$f" \
        --replace-quiet ${lib.escapeShellArg swiftc.out} "$out"
    done

    # Don’t propagate CMake files for toolchain dependencies. These are an implementation detail of the package set.
    rm -rf "$out/lib/cmake"

    recordPropagatedDependencies

    chmod -R u-w "$out/bin" "$out/lib" "$out/nix-support"
  '';

  __structuredAttrs = true;

  passthru = {
    inherit swiftc;
  };

  meta = {
    description = "Swift Programming Language";
    homepage = "https://github.com/swiftlang/swift";
    inherit (swiftc.meta) platforms badPlatforms;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
