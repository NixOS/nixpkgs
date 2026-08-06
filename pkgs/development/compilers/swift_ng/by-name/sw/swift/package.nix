{
  lib,
  apple-sdk_14,
  apple-sdk_26,
  llvmPackages_upstream,
  stdenv,
  swift-corelibs-libdispatch,
  swiftc,
  symlinkJoin,
  swift_release,
}:

let
  # Need to use an older SDK if `swiftc` does not support macros.
  propagated-sdk = if swiftc.supportsMacros then apple-sdk_26 else apple-sdk_14;

  # `out` and `dev` are merged because that’s what Swift expects.
  outLinks = symlinkJoin {
    name = "swift" + lib.removePrefix "swiftc" (lib.getName swiftc) + "-${swift_release}-out";
    paths = [
      swiftc.out
      swiftc.dev
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) (
      lib.optionals (swift-corelibs-libdispatch != null) [
        swift-corelibs-libdispatch.out
        swift-corelibs-libdispatch.dev
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
        swift-corelibs-libdispatch.out
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
