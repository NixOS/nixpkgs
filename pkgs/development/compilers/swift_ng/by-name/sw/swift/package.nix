{
  lib,
  config,
  apple-sdk_14,
  apple-sdk_26,
  callPackage,
  llvmPackages,
  llvmPackages_upstream,
  patchelf,
  stdenv,
  stdlib,
  swift-corelibs-foundation,
  swift-corelibs-libdispatch,
  swift-corelibs-xctest,
  swift-driver,
  swift-foundation,
  swift-foundation-icu,
  swift-testing,
  swiftc,
  symlinkJoin,
  swift_release,
  enableRepl ? true, # Whether to build and include LLDB for the Swift REPL.
}:

let
  includeTesting = swiftc.supportsMacros && swift-testing != null;

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
    ++ lib.optionals enableRepl [
      # LLDB is used by `swift repl` to provide the REPL.
      llvmPackages.lldb.out
    ]
    ++ lib.optionals includeTesting [
      swift-corelibs-xctest.dev
      swift-corelibs-xctest.out
      swift-testing.dev
      swift-testing.out
    ]
    ++ lib.optionals (stdlib != null) [
      stdlib.dev
      stdlib.out
      swiftc.dev
    ]
    ++ lib.optionals (swift-driver != null) [
      swift-driver.out
      swift-driver.dev
      swift-driver.lib
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
    ++ lib.optionals (stdlib != null) [
      # Propagate the stdlib to make sure the linker wrapper will pick up the dynamic and static libraries.
      stdlib
    ]
    ++ lib.optionals includeTesting [
      swift-corelibs-xctest.out
      swift-testing.out
    ]
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

    # Make sure `swift` and `swiftc` point to `swift-driver` if present.
    if [ -e "$out/bin/swift-driver" ]; then
      for exe in swift swiftc; do
        rm -f "$out/bin/$exe"
        ln -s swift-driver "$out/bin/$exe"
      done
    fi

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

    ${lib.optionalString (stdlib != null) ''
      # Can’t use `replaceVars` because it needs to substitute $out.
      substitute ${./setup-hook.sh} "$out/nix-support/setup-hook" \
        --replace-fail @patchelf@ ${lib.escapeShellArg (lib.getExe patchelf)} \
        --replace-fail @objdump@ ${lib.escapeShellArg (lib.getExe' llvmPackages_upstream.llvm "llvm-objdump")} \
        --replace-fail @install_name_tool@ ${lib.escapeShellArg (lib.getExe' llvmPackages_upstream.llvm "llvm-install-name-tool")} \
        --replace-fail @stdlibPath@ ${lib.escapeShellArg stdlib.out} \
        --replace-fail @swiftPath@ "$out" \
        --replace-fail @swiftPlatform@ ${stdenv.hostPlatform.swift.platform}
    ''}
    ${lib.optionalString enableRepl ''
      # LLDB expects to find Swift relative to its location. Both the wrapper and its binary need copied,
      # and the wrapper needs updated to find the binary in the new location.
      lldbBinPath=$(dirname $(readlink "$out/bin/lldb"))
      for lldbExe in lldb .lldb-wrapped; do
        rm "$out/bin/$lldbExe"
        cp "$lldbBinPath/$lldbExe" "$out/bin/$lldbExe"
      done
      substituteInPlace "$out/bin/lldb" \
        --replace-fail "$lldbBinPath" "$out/bin"
      ${lib.optionalString stdenv.hostPlatform.isElf ''
        # LLDB tries to find the Swift resource folder relative to where it finds `liblldb.so` via RPATH.
        oldRpaths=$(patchelf --print-rpath "$out/bin/.lldb-wrapped")
        lldbRpath=${lib.escapeShellArg llvmPackages.lldb.out}

        chmod u+w "$out/bin/.lldb-wrapped"
        patchelf --set-rpath "''${oldRpaths/$lldbRpath/$out}" "$out/bin/.lldb-wrapped"
      ''}
    ''}
    chmod -R u-w "$out/bin" "$out/lib" "$out/nix-support"
  '';

  __structuredAttrs = true;

  passthru = {
    inherit swiftc swift-driver;
    tests = lib.packagesFromDirectoryRecursive {
      inherit callPackage;
      directory = ./tests;
    };

    # Swift libraries are installed in `lib` to make it easier to use Nixpkgs tooling with them.
    swiftLibSubdir = "lib";
    swiftStaticLibSubdir = "lib";

    # Our toolchain builds install modules in `lib/swift/<platform>`, which matches what upstream toolchains do.
    swiftModuleSubdir = "lib/swift/${stdenv.hostPlatform.swift.platform}";
    swiftStaticModuleSubdir = "lib/swift_static/${stdenv.hostPlatform.swift.platform}";
  }
  // lib.optionalAttrs config.allowAliases {
    # Legacy aliases for the old Swift packaging. These should eventually be removed.
    swift = lib.warnOnInstantiate "`swift` is an alias for this (`swift`) package. Just use it directly." finalAttrs.finalPackage;
    swiftArch = lib.warnOnInstantiate "'swiftArch' is an alias for 'stdenv.hostPlatform.swift.arch'." stdenv.hostPlatform.swift.arch;
    swiftDriver = lib.warnOnInstantiate "'swiftDriver' has been renamed to 'swift-driver'" finalAttrs.passthru.swift-driver;
    swiftOs = lib.warnOnInstantiate "'swiftOs' is an alias for 'stdenv.hostPlatform.swift.platform'." stdenv.hostPlatform.swift.platform;
  };

  meta = {
    description = "Swift Programming Language";
    homepage = "https://github.com/swiftlang/swift";
    inherit (swiftc.meta) platforms badPlatforms;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
