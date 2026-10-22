{
  lib,
  createToolchainStubsHook,
  llvmPackages,
  llvmPackages_upstream,
  stdenv,
  swiftc,
  swift_release,
}:

let
  swiftPlatform = stdenv.hostPlatform.swift.platform;
  libraryExtension = stdenv.hostPlatform.extensions.library;

  # Swift 6.2 is used as a bootstrap compiler. Disable LTO for its stdlib to improve build time.
  enableLTO = lib.versions.majorMinor swift_release != "6.2";
  toolLTO = lib.cmakeFeature "SWIFT_TOOLS_ENABLE_LTO" "thin";
in
(swiftc.override {
  stdlib = null;
  swiftComponents = [
    "back-deployment"
    "sdk-overlay"
    "static-mirror-lib"
    "swift-remote-mirror"
    "swift-remote-mirror-headers"
    "stdlib"
  ];
}).overrideAttrs
  (old: {
    pname = "stdlib";

    outputs = [
      "out"
      "dev"
    ];

    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ createToolchainStubsHook ];

    cmakeFlags =
      # Only enable LTO for the stdlib. Remove it if it’s enabled for the tools.
      (lib.filter (flag: flag != toolLTO) (old.cmakeFlags or [ ]))
      # LTO is slow (and pointless due to using system libraries) on Darwin, so only enable it for other platforms.
      ++ lib.optionals (enableLTO && !stdenv.hostPlatform.isDarwin) [
        (lib.cmakeFeature "SWIFT_STDLIB_ENABLE_LTO" "thin")
      ];

    postInstall = ''
      moveToOutput "lib/swift/${swiftPlatform}" "''${!outputLib}"

      # Static libraries, Swift modules, and shims are only needed for development.
      moveToOutput "lib/swift/${swiftPlatform}/*.swiftmodule" "''${!outputDev}"
      moveToOutput "lib/swift/_InternalSwiftStaticMirror" "''${!outputDev}"
      moveToOutput "lib/swift/embedded" "''${!outputDev}"
      moveToOutput "lib/swift/module.modulemap" "''${!outputDev}"
      moveToOutput "lib/swift/shims" "''${!outputDev}"
      moveToOutput "lib/swift_static" "''${!outputDev}"

      # Move libraries out of `lib/swift/`, so ld-wrapper will find them automatically.
      mv -v "''${!outputLib}/lib/swift/${swiftPlatform}"/*${libraryExtension} "''${!outputLib}/lib"

      # Install C++ interop libraries and headers
      cp -v lib/swift/${swiftPlatform}/libswiftCxx*${stdenv.hostPlatform.extensions.staticLibrary} "''${!outputDev}/lib/swift/${swiftPlatform}"
      cp -rv lib/swift/${swiftPlatform}/Cxx*.swiftmodule "''${!outputDev}/lib/swift/${swiftPlatform}"

      mkdir -p "''${!outputDev}/include/swiftToCxx"
      cp -v ../lib/PrintAsClang/{_SwiftCxxInteroperability.h,_SwiftStdlibCxxOverlay.h,experimental-interoperability-version.json} \
        "''${!outputDev}/include/swiftToCxx"
      cp -v lib/swift/${swiftPlatform}/libcxx* "''${!outputDev}/lib/swift/${swiftPlatform}"
    ''
    # libstdc++ does not come with a modulemap. It needs one provided by Swift.
    + lib.optionalString (stdenv.cc.libcxx == null) ''
      moveToOutput "lib/swift/${swiftPlatform}/libstdcxx.*" "''${!outputDev}"
    ''
    # Linux has some extra development files that need moved to $dev
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      moveToOutput lib/swift/${swiftPlatform}/${stdenv.hostPlatform.swift.arch} "''${!outputDev}"
    ''
    # Convert LLVM bitcode files into native code to avoid requiring LTO for C++ interop.
    # Note: This could be done with llc, but it crashes when converting object files from the Swift 6.3.3 stdlib.
    + lib.optionalString (enableLTO && stdenv.hostPlatform.isElf) ''
      LLVM_DIS=${lib.escapeShellArg (lib.getExe' llvmPackages.llvm "llvm-dis")}
      CLANG=${lib.escapeShellArg (lib.getExe' llvmPackages.clang.cc "clang")}
      "$LLVM_DIS" stdlib/public/Cxx/${lib.toUpper stdenv.hostPlatform.swift.platform}/${stdenv.hostPlatform.swift.arch}/Cxx.o -o Cxx.ll
      "$CLANG" -c Cxx.ll -o Cxx.o
      "$AR" Drs "''${!outputDev}/lib/swift/${swiftPlatform}/libswiftCxx.a" Cxx.o
      "$LLVM_DIS" stdlib/public/Cxx/std/${lib.toUpper stdenv.hostPlatform.swift.platform}/${stdenv.hostPlatform.swift.arch}/CxxStdlib.o -o CxxStdlib.ll
      "$CLANG" -c CxxStdlib.ll -o CxxStdlib.o
      "$AR" Drs "''${!outputDev}/lib/swift/${swiftPlatform}/libswiftCxxStdlib.a" CxxStdlib.o
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Back-deployment libraries are installed as part of the compiler component, so install them manually.
      cp -rv lib/swift/${swiftPlatform}/libswiftCompatibility*.a "''${!outputDev}/lib/swift/${swiftPlatform}"

      # Install `Span`-compatibility back-deployment library.
      mkdir -p "''${!outputLib}/lib/swift-6.2/${swiftPlatform}"
      cp -v lib/swift-6.2/${swiftPlatform}/libswiftCompatibilitySpan.dylib "''${!outputLib}/lib/swift-6.2/${swiftPlatform}/libswiftCompatibilitySpan.dylib"

      # macOS 26.4 dropped the Swift Differentiation dylibs. Use the one in the store instead of `/usr/lib/swift`.
      install_name_tool "''${!outputLib}/lib/libswift_Differentiation.dylib" -id "''${!outputLib}/lib/libswift_Differentiation.dylib"
    '';

    postFixup =
      # Remove the dylibs from the stdlib. Darwin links against the system library, so they aren’t necessary.
      # The exception is `libswift_Differentiation.dylib`, which macOS no longer ships in the dyld cache.
      lib.optionalString stdenv.hostPlatform.isDarwin ''
        for dylib in "''${!outputLib}/lib/"*.dylib; do
          dylibName=$(basename "$dylib" .dylib)
          case "$dylibName" in
            libswift_Differentiation)
              # Swift Differentiation needs to symlink the dylib to ensure that it can be imported in Swift scripts.
              rm "''${!outputDev}/lib/swift/${swiftPlatform}/$dylibName.tbd"
              ln -s "''${!outputLib}/lib/$dylibName.dylib" "''${!outputDev}/lib/swift/${swiftPlatform}/$dylibName.dylib"
              ;;
            libswiftCompatibilitySpan)
              # Follow the SDK, which symlinks `libswiftCompatibilitySpan.tbd` to `libswiftCore.tbd`.
              rm "''${!outputDev}/lib/swift/${swiftPlatform}/$dylibName.tbd"
              ln -s libswiftCore.tbd "''${!outputDev}/lib/swift/${swiftPlatform}/$dylibName.tbd"
              ;& # Fall through to remove the dylib.
            *)
              rm "$dylib"
              # Copy the stubs back to $lib. This is needed for compatibility with packages that link Swift libraries
              # directly without going through `swiftc` (mostly the source-based .NET builds).
              cp "''${!outputDev}/lib/swift/${swiftPlatform}/$dylibName.tbd" "''${!outputLib}/lib/$dylibName.tbd"
              ;;
          esac
        done

        # The linker should be using the stubs in $dev, which will reference the dylibs in $lib.
        # There’s no need to propagate it on Darwin.
        rm -rf "''${!outputDev}/nix-support"

        # Clean up empty folders.
        rmdir "''${!outputLib}/lib/swift/${swiftPlatform}" "''${!outputLib}/lib/swift"
      '';
  })
