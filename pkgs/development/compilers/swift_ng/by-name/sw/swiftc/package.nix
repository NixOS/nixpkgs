{
  lib,
  apple-sdk_14,
  bootstrapStage,
  buildSwiftPackages,
  cmake,
  darwin,
  fetchFromGitHub,
  fetchpatch2,
  libedit,
  libffi,
  libuuid,
  libxml2,
  llvmPackages,
  llvm_libtool,
  ninja,
  perl,
  python3,
  replaceVars,
  srcOnly,
  stdenv,
  swift-cmark,
  swift-corelibs-libdispatch,
  swift-syntax,
  xcbuild,
  xz,
  zlib,
  zstd,
  swift_release,
  swift_sources,
  # This matches _SWIFT_DEFAULT_COMPONENTS, with specific components disabled.
  swiftComponents ? [
    "autolink-driver"
    #    "clang-builtin-headers"
    #    "clang-resource-dir-symlink"
    "compiler"
    "compiler-swift-syntax-lib"
    #    "dev"
    "editor-integration"
    #    "llvm-toolchain-dev-tools"
    "license"
    "sdk-overlay"
    (if stdenv.hostPlatform.isDarwin then "sourcekit-xpc-service" else "sourcekit-inproc")
    #    "stdlib-experimental"
    "swift-syntax-lib"
    #    "testsuite-tools"
    "toolchain-dev-tools"
    "toolchain-tools"
    #    "tools"
    "back-deployment"
    "sdk-overlay"
    "static-mirror-lib"
    "stdlib"
    "swift-remote-mirror"
    "swift-remote-mirror-headers"
  ],
}:

let
  build-sdk = apple-sdk_14;

  swift = buildSwiftPackages.swift;

  inherit (llvmPackages)
    clang
    clang-unwrapped
    llvm

    libclang
    libllvm
    ;

  inherit (darwin) sigtool;

  dylibExt = stdenv.hostPlatform.extensions.sharedLibrary;

  isNotSwiftSyntax = if bootstrapStage == 0 then c: !lib.hasInfix "swift-syntax" c else _: true;

  swiftComponents' = lib.filter isNotSwiftSyntax swiftComponents;

  srcs = {
    swift-experimental-string-processing = fetchFromGitHub {
      owner = "swiftlang";
      repo = "swift-experimental-string-processing";
      tag = "swift-${swift_release}-RELEASE";
      inherit (swift_sources.swift-experimental-string-processing) hash;
    };

    swift-syntax = srcOnly {
      inherit (swift-syntax)
        name
        version
        src
        patches
        stdenv
        ;
    };
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname =
    "swiftc"
    + lib.optionalString (bootstrapStage == 0) "-cxx_bootstrap"
    + lib.optionalString (bootstrapStage == 1) "-bootstrap";
  version = swift_release;

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift";
    tag = "swift-${swift_release}-RELEASE";
    inherit (swift_sources.swift) hash;
  };

  postUnpack = lib.optionalString (bootstrapStage >= 1) ''
    ln -s ${lib.escapeShellArg srcs.swift-experimental-string-processing} "$NIX_BUILD_TOP/swift-experimental-string-processing"
    ln -s ${lib.escapeShellArg srcs.swift-syntax} "$NIX_BUILD_TOP/swift-syntax"
  '';

  patches = [
    # ClangImporter needs help finding the location of libc and libc++ (and using it).
    ./patches/0001-Read-C-and-C-stdlib-flags-from-the-wrapped-compiler.patch
    ./patches/0002-Use-Nixpkgs-C-and-C-stdlib-paths-in-ClangImporter.patch
    # Backport linking against an external swift-cmark.
    # From https://github.com/swiftlang/swift/pull/70791.
    ./patches/0003-cmark-build-revamp.patch
    # Fix compilation errors when building the SIL module during bootstrap.
    # error: field has incomplete type 'clang::DeclContext::all_lookups_iterator'
    # error: field has incomplete type 'clang::DeclContext::ddiag_iterator'
    ./patches/0004-sil-missing-headers.patch
    # Use libLTO.dylib from the LLVM built for Swift
    (replaceVars ./patches/0005-specify-liblto-path.patch {
      libllvm_path = lib.getLib libllvm;
    })
    # Use libdispatch from nixpkgs instead of building it in-tree
    ./patches/0006-use-nixpkgs-libdispatch.patch
    # The Swift JIT needs help finding dylibs when they are linked into the toolchain at `$out/lib`.
    (replaceVars ./patches/0007-Help-Swift-JIT-find-the-separate-stdlib-and-framewor.patch {
      swiftPlatform = stdenv.hostPlatform.swift.platform;
    })
    # Fix missing <cstdint> when building against libstdc++ 15
    (fetchpatch2 {
      url = "https://github.com/swiftlang/swift/commit/a5c727125e952839c373fe47e9f9e359db3d4d38.patch?full_index=1";
      hash = "sha256-OoTcPyqTzAhkxaRAMeu+hab3yoIDRPq6YzK5hrLk4Jg=";
    })
    # Fix missing null-terminator on Linux, which results in a crash in `swift repl`.
    (fetchpatch2 {
      url = "https://github.com/swiftlang/swift/commit/cfbe70db5d1e65bed2388f97ee52f65719c812b3.patch?full_index=1";
      hash = "sha256-XxdP3Qs2YfT20d5E216cOQy+fUgYQpwMDWSyl77NQHw=";
    })
  ]
  ++ lib.optionals (bootstrapStage == 0) [
    # Revert optimizer changes that cause the C++-based bootstrap compiler to be unable to compile functions with
    # infinite loops that return from the loop. This doesn’t affect the later stages, so it’s applied conditionally.
    # https://github.com/swiftlang/swift/pull/79186
    ./patches/0008-revert-optimizer-changes.patch
    # Work around a compiler crash by partially reverting https://github.com/swiftlang/swift/pull/80920.
    ./patches/0009-siloptimizer-bootstrap-workaround.patch
  ]
  ++ lib.optionals (bootstrapStage == 1) [
    # Stage 1 doesn’t have a compiler that supports _StringProcessing.
    # This isn’t a problem on Darwin, but it fails on Linux.
    ./patches/0010-Remove-dependency-on-_StringProcessing-during-stage-.patch
  ];

  postPatch = ''
    # Swift doesn’t really _need_ LLVM’s build folder. It only needs to find a built LLVM, which we can provide.
    substituteInPlace cmake/modules/SwiftSharedCMakeConfig.cmake \
      --replace-fail "precondition_translate_flag(LLVM_BUILD_LIBRARY_DIR LLVM_LIBRARY_DIR)" ""

    # Fix the path to LLVM’s CMake modules.
    substituteInPlace lib/Basic/CMakeLists.txt \
      --replace-fail \''${LLVM_MAIN_SRC_DIR}/cmake/modules ${lib.escapeShellArg (lib.getDev libllvm)}/lib/cmake/llvm

    # Find `features.json` in Clang’s $out not LLVM’s.
    substituteInPlace lib/Option/CMakeLists.txt \
      --replace-fail \''${LLVM_BINARY_DIR} ${lib.escapeShellArg (lib.getBin clang-unwrapped)}

    # Make sure Swift can find Clang’s resource dir during the build.
    substituteInPlace stdlib/public/SwiftShims/swift/shims/CMakeLists.txt \
      --replace-fail \
        'set(clang_headers_location "''${LLVM_LIBRARY_OUTPUT_INTDIR}/clang/''${CLANG_VERSION${lib.optionalString (lib.versionAtLeast finalAttrs.version "6.0") "_MAJOR"}}")' \
        'set(clang_headers_location "${lib.getBin clang}/resource-root")'

    # Use absolute path references for `dlopen`.
    substituteInPlace stdlib/public/RuntimeModule/Compression.swift \
      --replace-fail liblzma${dylibExt} ${lib.escapeShellArg (lib.getLib xz)}/lib/liblzma${dylibExt} \
      --replace-fail libz${dylibExt} ${lib.escapeShellArg (lib.getLib zlib)}/lib/libz${dylibExt} \
      --replace-fail libzstd${dylibExt} ${lib.escapeShellArg (lib.getLib zstd)}/lib/libzstd${dylibExt}

    # Make sure Swift uses the external macro plugin server built with the compiler.
    substituteInPlace lib/Driver/DarwinToolChains.cpp \
      --replace-fail 'basePath, "usr", "bin", "swift-plugin-server"' "\"$out/bin/swift-plugin-server\""
  ''
  + lib.optionalString stdenv.targetPlatform.isDarwin ''
    # Swift sets the deployment target to 10.9 for some components, but nixpkgs only supports newer ones.
    # Overriding it eliminates errors due to -Wunguarded-availability.
    # substituteInPlace CMakeLists.txt \
    #   --replace-fail 'COMPATIBILITY_MINIMUM_DEPLOYMENT_VERSION_OSX "10.9"' 'COMPATIBILITY_MINIMUM_DEPLOYMENT_VERSION_OSX "${stdenv.targetPlatform.darwinMinVersion}"'

    # Only build the runtime for the target architecture. Universal builds aren’t really supported in nixpkgs,
    # and the dylibs in the SDK aren’t built as universal. Use `grep` to assert the change was made.
    sed -i cmake/modules/SwiftConfigureSDK.cmake \
      -e 's/^\( *\)remove_sdk_unsupported_archs(.*$/\1set(SWIFT_SDK_''${prefix}_ARCHITECTURES "${stdenv.targetPlatform.darwinArch}")/'
    grep -q 'set(SWIFT_SDK_''${prefix}_ARCHITECTURES "${stdenv.targetPlatform.darwinArch}")' cmake/modules/SwiftConfigureSDK.cmake
  '';

  dontFixCmake = true;

  cmakeFlags = [
    # The bootstrap is managed via Nix instead of upstream’s bootstrap-specific bootstrapping modes.
    (lib.cmakeFeature "BOOTSTRAPPING_MODE" "HOSTTOOLS")
    (lib.cmakeOptionType "list" "SWIFT_INSTALL_COMPONENTS" (lib.concatStringsSep ";" swiftComponents'))
    # Needs to be disabled in stage 0 to enable the C++ bootstrap.
    (lib.cmakeBool "SWIFT_ENABLE_SWIFT_IN_SWIFT" (bootstrapStage > 0))
    # Swift installs its dylibs to `$lib/lib/swift/host` instead of `$lib/lib`.
    (lib.cmakeFeature "CMAKE_INSTALL_NAME_DIR" "${placeholder "out"}/lib/swift/host")
    # Make Swift use Clang from nixpkgs instead of building its own.
    (lib.cmakeBool "SWIFT_PREBUILT_CLANG" true)
    (lib.cmakeFeature "SWIFT_NATIVE_CLANG_TOOLS_PATH" "${lib.getBin clang}/bin")
    (lib.cmakeFeature "SWIFT_NATIVE_LLVM_TOOLS_PATH" "${lib.getBin llvm}/bin")
    # Swift expects to find these relative to `$src`, but it only actually needs their final build products.
    # Instead of being built in the Swift derivation, they’re built separately. This tells CMake how to find them.
    (lib.cmakeFeature "Clang_DIR" "${lib.getDev libclang}/lib/cmake/clang")
    (lib.cmakeFeature "LLVM_DIR" "${lib.getDev libllvm}/lib/cmake/llvm")
    (lib.cmakeFeature "cmark-gfm_DIR" "${swift-cmark.out}/lib/cmake")
    # Swift defaults to 10.13, which is too old. Set the deployment target to the minimum supported in nixpkgs.
    (lib.cmakeFeature "SWIFT_DARWIN_DEPLOYMENT_VERSION_OSX" stdenv.hostPlatform.darwinMinVersion)
    (lib.cmakeFeature "SWIFT_HOST_TRIPLE" stdenv.hostPlatform.swift.triple)
    # Tests should only be built when building a regular compiler. The bootstrap compiler is not functional enough.
    (lib.cmakeBool "SWIFT_INCLUDE_TESTS" false)
    # Swift Concurrency is needed to build the stage 1 compiler on Linux.
    (lib.cmakeBool "SWIFT_ENABLE_EXPERIMENTAL_CONCURRENCY" true)
  ]
  ++ lib.optionals (bootstrapStage == 1) [
    # Work around crashes in ownership verifier in the bootstrap compiler.
    # See https://github.com/swiftlang/swift/issues/84552#issuecomment-3409245634
    "-DCMAKE_Swift_FLAGS=-Xfrontend -disable-sil-ownership-verifier"
  ]
  ++ lib.optionals (bootstrapStage >= 1) [
    # These features are needed for the final build due to using unguarded macros in the SDK required to build it.
    (lib.cmakeBool "SWIFT_BUILD_SWIFT_SYNTAX" true)
    (lib.cmakeBool "SWIFT_ENABLE_EXPERIMENTAL_OBSERVATION" true)
    (lib.cmakeBool "SWIFT_ENABLE_EXPERIMENTAL_STRING_PROCESSING" true)
    # Synchronization is required to build Foundation.
    (lib.cmakeBool "SWIFT_ENABLE_SYNCHRONIZATION" true)
  ];

  env = {
    # Swift uses `<arch>-apple.macosx` triples instead of `<arch>-apple-darwin`, which causes tons of warnings.
    NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING = true;
    NIX_CFLAGS_COMPILE = toString (
      # Swift compiles some of its stdlib for older deployment targets without using availability checks.
      [ "-Wno-error=unguarded-availability" ]
    );
  };

  preConfigure =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      # `env.NIX_LDFLAGS` can’t be done conditionally because all obvious conditions cause infinite recursions.
      if [ $NIX_APPLE_SDK_VERSION -lt 260000 ]; then
        # Swift 6.2 needs to weakly link against `swift_coroFrameAlloc`, which is only in the 26.0 SDK.
        # Unfortunately, the 26.0 SDK uses unguarded macros, so the C++ bootstrap compiler has to use the 14.4 SDK.
        NIX_LDFLAGS+=" -undefined dynamic_lookup"
      fi
    ''
    + lib.optionalString (bootstrapStage >= 1) ''
      appendToVar cmakeFlags "-DSWIFT_PATH_TO_STRING_PROCESSING_SOURCE:PATH=$NIX_BUILD_TOP/swift-experimental-string-processing"
      appendToVar cmakeFlags "-DSWIFT_PATH_TO_SWIFT_SYNTAX_SOURCE:PATH=$NIX_BUILD_TOP/swift-syntax"
    '';

  postConfigure = ''
    # Make sure `swift` can locate the C and C++ standard library relative to `swift` binary in `bin`.
    ln -s ${lib.escapeShellArg (lib.getExe' clang "clang")} bin/clang
  '';

  strictDeps = true;

  ninjaFlags = swiftComponents';

  nativeBuildInputs = [
    cmake
    ninja
    perl # For pod2man
    python3
    swift
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvm_libtool
    sigtool
    xcbuild
  ];

  buildInputs = [
    libedit
    libffi
    libllvm
    libxml2
    swift-cmark.out
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ build-sdk ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libuuid
    (swift-corelibs-libdispatch.override { useSwift = false; })
  ];

  postInstall = ''
    # Swift has a separate resource root from Clang, but locates the Clang
    # resource root via subdir or symlink.
    #
    # NOTE: We don't symlink directly here, because that'd add a run-time dep
    # on the full Clang compiler to every Swift executable. The copy here is
    # just copying the 3 symlinks inside to smaller closures.
    mkdir -p "''${!outputLib}/lib/swift/clang"
    cp -P ${lib.escapeShellArg (lib.getBin clang)}/resource-root/* "''${!outputLib}/lib/swift/clang/"

    # Swift 6 installs private Swift Syntax dylibs to $lib/lib/swift/host/compiler, which `CMAKE_INSTALL_NAME_DIR`
    # mangles to the wrong paths.
    # Fix up the install names of all the dylibs generated by the build process. fixupDarwinDylibNames doesn’t work.
    while IFS= read -d "" dylib; do
      dylib_name=$(basename "$dylib")
      echo "$dylib: fixing dylib"
      install_name_tool "$dylib" -id "$dylib"
    done < <(find "''${!outputLib}/lib/swift/host/compiler" -name '*.dylib' -print0)
    readarray -t -d "" args < <(
      find "''${!outputLib}/lib/swift/host/compiler" -name '*.dylib' \
        -printf "-change\0''${!outputLib}/lib/swift/host/%f\0%p\0"
    )
    while IFS= read -d "" exe; do
      if [[ "$exe" != *.a ]] && LC_ALL=C isMachO "$exe"; then
        res=$(install_name_tool "$exe" "''${args[@]}" 2>&1)
        if [[ "$res" =~ invalidate ]]; then codesign -s - -f "$exe"; fi
      fi
    done < <(find "$out" -type f -print0)
  '';

  passthru.supportsMacros = bootstrapStage >= 1;

  __structuredAttrs = true;

  meta = {
    description = "Swift Programming Language";
    homepage = "https://github.com/swiftlang/swift";
    mainProgram = "swiftc";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    badPlatforms = [ lib.systems.inspect.patterns.is32bit ];
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
