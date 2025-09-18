{
  lib,
  stdenv,
  callPackage,
  cmake,
  bash,
  coreutils,
  gnugrep,
  perl,
  ninja_1_11,
  pkg-config,
  clang,
  bintools,
  python312Packages,
  git,
  fetchpatch,
  fetchpatch2,
  makeWrapper,
  gnumake,
  file,
  runCommand,
  writeShellScriptBin,
  # For lldb
  libedit,
  ncurses,
  swig,
  libxml2,
  # Linux-specific
  glibc,
  libuuid,
  # Darwin-specific
  replaceVars,
  fixDarwinDylibNames,
  xcbuild,
  cctools, # libtool
  sigtool,
  DarwinTools,
  apple-sdk_14,
  darwinMinVersionHook,
}:

let
  apple-sdk_swift = apple-sdk_14; # Use the SDK that was available when Swift shipped.

  deploymentVersion =
    if lib.versionOlder (targetPlatform.darwinMinVersion or "0") "10.15" then
      "10.15"
    else
      targetPlatform.darwinMinVersion;

  # Use Python 3.12 for now because Swift 5.8 depends on Python's PyEval_ThreadsInitialized(), which was removed in 3.13.
  python3 = python312Packages.python.withPackages (p: [ p.setuptools ]); # python 3.12 compat.

  inherit (stdenv) hostPlatform targetPlatform;

  sources = callPackage ../sources.nix { };

  # There are apparently multiple naming conventions on Darwin. Swift uses the
  # xcrun naming convention. See `configure_sdk_darwin` calls in CMake files.
  swiftOs =
    if targetPlatform.isDarwin then
      {
        "macos" = "macosx";
        "ios" = "iphoneos";
        #iphonesimulator
        #appletvos
        #appletvsimulator
        #watchos
        #watchsimulator
      }
      .${targetPlatform.darwinPlatform}
        or (throw "Cannot build Swift for target Darwin platform '${targetPlatform.darwinPlatform}'")
    else
      targetPlatform.parsed.kernel.name;

  # This causes swiftPackages.XCTest to fail to build on aarch64-linux
  # as I believe this is because Apple calls the architecture aarch64
  # on Linux rather than arm64 when used with macOS.
  swiftArch =
    if hostPlatform.isDarwin then hostPlatform.darwinArch else targetPlatform.parsed.cpu.name;

  # On Darwin, a `.swiftmodule` is a subdirectory in `lib/swift/<OS>`,
  # containing binaries for supported archs. On other platforms, binaries are
  # installed to `lib/swift/<OS>/<ARCH>`. Note that our setup-hook also adds
  # `lib/swift` for convenience.
  swiftLibSubdir = "lib/swift/${swiftOs}";
  swiftModuleSubdir =
    if hostPlatform.isDarwin then "lib/swift/${swiftOs}" else "lib/swift/${swiftOs}/${swiftArch}";

  # And then there's also a separate subtree for statically linked  modules.
  toStaticSubdir = lib.replaceStrings [ "/swift/" ] [ "/swift_static/" ];
  swiftStaticLibSubdir = toStaticSubdir swiftLibSubdir;
  swiftStaticModuleSubdir = toStaticSubdir swiftModuleSubdir;

  # This matches _SWIFT_DEFAULT_COMPONENTS, with specific components disabled.
  swiftInstallComponents = [
    "autolink-driver"
    "compiler"
    # "clang-builtin-headers"
    "stdlib"
    "sdk-overlay"
    "static-mirror-lib"
    "editor-integration"
    # "tools"
    # "testsuite-tools"
    "toolchain-tools"
    "toolchain-dev-tools"
    "license"
    (if stdenv.hostPlatform.isDarwin then "sourcekit-xpc-service" else "sourcekit-inproc")
    "swift-remote-mirror"
    "swift-remote-mirror-headers"
  ];

  clangForWrappers = clang.override (prev: {
    extraBuildCommands =
      prev.extraBuildCommands
      # We need to use the resource directory corresponding to Swift’s
      # version of Clang instead of passing along the one from the
      # `cc-wrapper` flags.
      + ''
        substituteInPlace $out/nix-support/cc-cflags \
          --replace-fail " -resource-dir=$out/resource-root" ""
      '';
  });

  # Build a tool used during the build to create a custom clang wrapper, with
  # which we wrap the clang produced by the swift build.
  #
  # This is used in a `POST_BUILD` for the CMake target, so we rename the
  # actual clang to clang-unwrapped, then put the wrapper in place.
  #
  # We replace the `exec ...` command with `exec -a "$0"` in order to
  # preserve $0 for clang. This is because, unlike Nix, we don't have
  # separate wrappers for clang/clang++, and clang uses $0 to detect C++.
  #
  # Similarly, the C++ detection in the wrapper itself also won't work for us,
  # so we base it on $0 as well.
  makeClangWrapper = writeShellScriptBin "nix-swift-make-clang-wrapper" ''
    set -euo pipefail

    targetFile="$1"
    unwrappedClang="$targetFile-unwrapped"

    mv "$targetFile" "$unwrappedClang"
    sed < '${clangForWrappers}/bin/clang' > "$targetFile" \
      -e 's|^\s*exec|exec -a "$0"|g' \
      -e 's|^\[\[ "${clang.cc}/bin/clang" = \*++ ]]|[[ "$0" = *++ ]]|' \
      -e "s|${clang.cc}/bin/clang|$unwrappedClang|g" \
      -e "s|^\(\s*\)\($unwrappedClang\) \"@\\\$responseFile\"|\1argv0=\$0\n\1${bash}/bin/bash -c \"exec -a '\$argv0' \2 '@\$responseFile'\"|" \
    ${lib.optionalString (clang.libcxx != null) ''
      -e 's|$NIX_CXXSTDLIB_COMPILE_${clang.suffixSalt}|-isystem '$SWIFT_BUILD_ROOT'/libcxx/include/c++/v1|g'
    ''}
    chmod a+x "$targetFile"
  '';

  # Create a tool used during the build to create a custom swift wrapper for
  # each of the swift executables produced by the build.
  #
  # The build produces several `swift-frontend` executables during
  # bootstrapping. Each of these has numerous aliases via symlinks, and the
  # executable uses $0 to detect what tool is called.
  wrapperParams = {
    inherit bintools;
    coreutils_bin = lib.getBin coreutils;
    gnugrep_bin = gnugrep;
    suffixSalt = lib.replaceStrings [ "-" "." ] [ "_" "_" ] targetPlatform.config;
    use_response_file_by_default = 1;
    swiftDriver = "";
    # NOTE: @cc_wrapper@ and @prog@ need to be filled elsewhere.
  };
  swiftWrapper = runCommand "swift-wrapper.sh" wrapperParams ''
    # Make empty to avoid adding the SDK’s modules in the bootstrap wrapper. Otherwise, the SDK conflicts with the
    # shims the wrapper tries to build.
    darwinMinVersion="" substituteAll '${../wrapper/wrapper.sh}' "$out"
  '';
  makeSwiftcWrapper = writeShellScriptBin "nix-swift-make-swift-wrapper" ''
    set -euo pipefail

    targetFile="$1"
    unwrappedSwift="$targetFile-unwrapped"

    mv "$targetFile" "$unwrappedSwift"
    sed < '${swiftWrapper}' > "$targetFile" \
      -e "s|@prog@|'$unwrappedSwift'|g" \
      -e 's|@cc_wrapper@|${clangForWrappers}|g' \
      -e 's|exec "$prog"|exec -a "$0" "$prog"|g' \
    ${lib.optionalString (clang.libcxx != null) ''
      -e 's|$NIX_CXXSTDLIB_COMPILE_${clang.suffixSalt}|-isystem '$SWIFT_BUILD_ROOT'/libcxx/include/c++/v1|g'
    ''}
    chmod a+x "$targetFile"
  '';

  # On Darwin, we need to use BOOTSTRAPPING-WITH-HOSTLIBS because of ABI
  # stability, and have to provide the definitions for the system stdlib.
  appleSwiftCore = stdenv.mkDerivation {
    name = "apple-swift-core";
    dontUnpack = true;

    buildInputs = [ apple-sdk_swift ];

    installPhase = ''
      mkdir -p $out/lib/swift
      cp -r \
        "$SDKROOT/usr/lib/swift/Swift.swiftmodule" \
        "$SDKROOT/usr/lib/swift/CoreFoundation.swiftmodule" \
        "$SDKROOT/usr/lib/swift/Dispatch.swiftmodule" \
        "$SDKROOT/usr/lib/swift/ObjectiveC.swiftmodule" \
        "$SDKROOT/usr/lib/swift/libswiftCore.tbd" \
        "$SDKROOT/usr/lib/swift/libswiftCoreFoundation.tbd" \
        "$SDKROOT/usr/lib/swift/libswiftDispatch.tbd" \
        "$SDKROOT/usr/lib/swift/libswiftFoundation.tbd" \
        "$SDKROOT/usr/lib/swift/libswiftObjectiveC.tbd" \
        $out/lib/swift/
    '';
  };

  # https://github.com/NixOS/nixpkgs/issues/327836
  # Fail to build with ninja 1.12 when NIX_BUILD_CORES is low (Hydra or Github Actions).
  # Can reproduce using `nix --option cores 2 build -f . swiftPackages.swift-unwrapped`.
  # Until we find out the exact cause, follow [swift upstream][1], pin ninja to version
  # 1.11.1.
  # [1]: https://github.com/swiftlang/swift/pull/72989
  ninja = ninja_1_11;

in
stdenv.mkDerivation {
  pname = "swift";
  inherit (sources) version;

  outputs = [
    "out"
    "lib"
    "dev"
    "doc"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    git
    ninja
    perl # pod2man
    pkg-config
    python3
    makeWrapper
    makeClangWrapper
    makeSwiftcWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
    sigtool # codesign
    DarwinTools # sw_vers
    fixDarwinDylibNames
    cctools.libtool
  ];

  buildInputs = [
    # For lldb
    python3
    swig
    libxml2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libuuid
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_swift
  ];

  # Will effectively be `buildInputs` when swift is put in `nativeBuildInputs`.
  depsTargetTargetPropagated = lib.optionals stdenv.targetPlatform.isDarwin [
    apple-sdk_swift
  ];

  # This is a partial reimplementation of our setup hook. Because we reuse
  # the Swift wrapper for the Swift build itself, we need to do some of the
  # same preparation.
  postHook = ''
    for pkg in "''${pkgsHostTarget[@]}" '${clang.libc}'; do
      for subdir in ${swiftModuleSubdir} ${swiftStaticModuleSubdir} lib/swift; do
        if [[ -d "$pkg/$subdir" ]]; then
          export NIX_SWIFTFLAGS_COMPILE+=" -I $pkg/$subdir"
        fi
      done
      for subdir in ${swiftLibSubdir} ${swiftStaticLibSubdir} lib/swift; do
        if [[ -d "$pkg/$subdir" ]]; then
          export NIX_LDFLAGS+=" -L $pkg/$subdir"
        fi
      done
    done
  '';

  # We setup custom build directories.
  dontUseCmakeBuildDir = true;

  unpackPhase =
    let
      copySource = repo: "cp -r ${sources.${repo}} ${repo}";
    in
    ''
      mkdir src
      cd src

      ${copySource "swift-cmark"}
      ${copySource "llvm-project"}
      ${copySource "swift"}
      ${copySource "swift-experimental-string-processing"}
      ${copySource "swift-syntax"}
      ${lib.optionalString (!stdenv.hostPlatform.isDarwin) (copySource "swift-corelibs-libdispatch")}

      chmod -R u+w .
    '';

  patchPhase = ''
     # Just patch all the things for now, we can focus this later.
     # TODO: eliminate use of env.
     find -type f -print0 | xargs -0 sed -i \
     ${lib.optionalString stdenv.hostPlatform.isDarwin "-e 's|/usr/libexec/PlistBuddy|${xcbuild}/bin/PlistBuddy|g'"} \
       -e 's|/usr/bin/env|${coreutils}/bin/env|g' \
       -e 's|/usr/bin/make|${gnumake}/bin/make|g' \
       -e 's|/bin/mkdir|${coreutils}/bin/mkdir|g' \
       -e 's|/bin/cp|${coreutils}/bin/cp|g' \
       -e 's|/usr/bin/file|${file}/bin/file|g'

     patch -p1 -d swift -i ${./patches/swift-wrap.patch}
     patch -p1 -d swift -i ${./patches/swift-linux-fix-libc-paths.patch}
     patch -p1 -d swift -i ${
       replaceVars ./patches/swift-linux-fix-linking.patch {
         inherit clang;
       }
     }
     patch -p1 -d swift -i ${
       replaceVars ./patches/swift-darwin-plistbuddy-workaround.patch {
         inherit swiftArch;
       }
     }
     patch -p1 -d swift -i ${
       replaceVars ./patches/swift-prevent-sdk-dirs-warning.patch {
         inherit (builtins) storeDir;
       }
     }

     # This patch needs to know the lib output location, so must be substituted
     # in the same derivation as the compiler.
     storeDir="${builtins.storeDir}" \
       substituteAll ${./patches/swift-separate-lib.patch} $TMPDIR/swift-separate-lib.patch
     patch -p1 -d swift -i $TMPDIR/swift-separate-lib.patch

     patch -p1 -d llvm-project/llvm -i ${./patches/llvm-module-cache.patch}

     for lldbPatch in ${
       lib.escapeShellArgs [
         # Fix the build with modern libc++.
         (fetchpatch {
           name = "add-cstdio.patch";
           url = "https://github.com/llvm/llvm-project/commit/73e15b5edb4fa4a77e68c299a6e3b21e610d351f.patch";
           stripLen = 1;
           hash = "sha256-eFcvxZaAuBsY/bda1h9212QevrXyvCHw8Cr9ngetDr0=";
         })
         (fetchpatch {
           url = "https://github.com/llvm/llvm-project/commit/68744ffbdd7daac41da274eef9ac0d191e11c16d.patch";
           stripLen = 1;
           hash = "sha256-QCGhsL/mi7610ZNb5SqxjRGjwJeK2rwtsFVGeG3PUGc=";
         })
       ]
     }; do
       patch -p1 -d llvm-project/lldb -i $lldbPatch
     done

     patch -p1 -d llvm-project/clang -i ${./patches/clang-toolchain-dir.patch}
     patch -p1 -d llvm-project/clang -i ${./patches/clang-wrap.patch}
     patch -p1 -d llvm-project/clang -i ${./patches/clang-purity.patch}

     patch -p1 -d llvm-project/cmake -i ${
       fetchpatch2 {
         name = "cmake-fix.patch";
         url = "https://github.com/llvm/llvm-project/commit/3676a86a4322e8c2b9c541f057b5d3704146b8f3.patch?full_index=1";
         stripLen = 1;
         hash = "sha256-zP9dQOmWs7qrxkBRj70DyQBbRjH78B6tNJVy6ilA1xM=";
       }
     }

     ${lib.optionalString stdenv.hostPlatform.isLinux ''
       substituteInPlace llvm-project/clang/lib/Driver/ToolChains/Linux.cpp \
         --replace 'SysRoot + "/lib' '"${glibc}/lib" "' \
         --replace 'SysRoot + "/usr/lib' '"${glibc}/lib" "' \
         --replace 'LibDir = "lib";' 'LibDir = "${glibc}/lib";' \
         --replace 'LibDir = "lib64";' 'LibDir = "${glibc}/lib";' \
         --replace 'LibDir = X32 ? "libx32" : "lib64";' 'LibDir = "${glibc}/lib";'

       # uuid.h is not part of glibc, but of libuuid.
       sed -i 's|''${GLIBC_INCLUDE_PATH}/uuid/uuid.h|${libuuid.dev}/include/uuid/uuid.h|' \
         swift/stdlib/public/Platform/glibc.modulemap.gyb
     ''}

     # Remove tests for cross compilation, which we don't currently support.
     rm swift/test/Interop/Cxx/class/constructors-copy-irgen-*.swift
     rm swift/test/Interop/Cxx/class/constructors-irgen-*.swift

     # TODO: consider fixing and re-adding. This test fails due to a non-standard "install_prefix".
     rm swift/validation-test/Python/build_swift.swift

     # We cannot handle the SDK location being in "Weird Location" due to Nix isolation.
     rm swift/test/DebugInfo/compiler-flags.swift

     # TODO: Fix issue with ld.gold invoked from script finding crtbeginS.o and crtendS.o.
     rm swift/test/IRGen/ELF-remove-autolink-section.swift

     # The following two tests fail because we use don't use the bundled libicu:
     # [SOURCE_DIR/utils/build-script] ERROR: can't find source directory for libicu (tried /build/src/icu)
     rm swift/validation-test/BuildSystem/default_build_still_performs_epilogue_opts_after_split.test
     rm swift/validation-test/BuildSystem/test_early_swift_driver_and_infer.swift

     # TODO: This test fails for some unknown reason
     rm swift/test/Serialization/restrict-swiftmodule-to-revision.swift

     # This test was flaky in ofborg, see #186476
     rm swift/test/AutoDiff/compiler_crashers_fixed/issue-56649-missing-debug-scopes-in-pullback-trampoline.swift

     patchShebangs .

     ${lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
       patch -p1 -d swift-corelibs-libdispatch -i ${
         # Fix the build with modern Clang.
         fetchpatch {
           url = "https://github.com/swiftlang/swift-corelibs-libdispatch/commit/30bb8019ba79cdae0eb1dc0c967c17996dd5cc0a.patch";
           hash = "sha256-wPZQ4wtEWk8HaKMfzjamlU6p/IW5EFiTssY63rGM+ZA=";
         }
       }
     ''}
  '';

  # > clang-15-unwrapped: error: unsupported option '-fzero-call-used-regs=used-gpr' for target 'arm64-apple-macosx10.9.0'
  # > clang-15-unwrapped: error: argument unused during compilation: '-fstack-clash-protection' [-Werror,-Wunused-command-line-argument]
  hardeningDisable = lib.optionals stdenv.hostPlatform.isAarch64 [
    "zerocallusedregs"
    "stackclashprotection"
  ];

  configurePhase = ''
    export SWIFT_SOURCE_ROOT="$PWD"
    mkdir -p ../build
    cd ../build
    export SWIFT_BUILD_ROOT="$PWD"
  '';

  # These steps are derived from doing a normal build with.
  #
  #   ./swift/utils/build-toolchain test --dry-run
  #
  # But dealing with the custom Python build system is far more trouble than
  # simply invoking CMake directly. Few variables it passes to CMake are
  # actually required or non-default.
  #
  # Using CMake directly also allows us to split up the already large build,
  # and package Swift components separately.
  #
  # Besides `--dry-run`, another good way to compare build changes between
  # Swift releases is to diff the scripts:
  #
  #   git diff swift-5.6.3-RELEASE..swift-5.7-RELEASE -- utils/build*
  #
  buildPhase = ''
    # Helper to build a subdirectory.
    #
    # Always reset cmakeFlags before calling this. The cmakeConfigurePhase
    # amends flags and would otherwise keep expanding it.
    function buildProject() {
      mkdir -p $SWIFT_BUILD_ROOT/$1
      cd $SWIFT_BUILD_ROOT/$1

      cmakeDir=$SWIFT_SOURCE_ROOT/''${2-$1}
      cmakeConfigurePhase

      ninjaBuildPhase
    }

    cmakeFlags="-GNinja"
    buildProject swift-cmark

    ${lib.optionalString (clang.libcxx != null) ''
      # Install the libc++ headers corresponding to the LLVM version of
      # Swift’s Clang.
      cmakeFlags="
        -GNinja
        -DLLVM_ENABLE_RUNTIMES=libcxx;libcxxabi
        -DLIBCXXABI_INSTALL_INCLUDE_DIR=$dev/include/c++/v1
      "
      ninjaFlags="install-cxx-headers install-cxxabi-headers"
      buildProject libcxx llvm-project/runtimes
      unset ninjaFlags
    ''}

    # Some notes:
    # - The Swift build just needs Clang.
    # - We can further reduce targets to just our targetPlatform.
    cmakeFlags="
      -GNinja
      -DLLVM_BUILD_TOOLS=NO
      -DLLVM_ENABLE_PROJECTS=clang
      -DLLVM_TARGETS_TO_BUILD=${
        {
          "x86_64" = "X86";
          "aarch64" = "AArch64";
        }
        .${targetPlatform.parsed.cpu.name}
          or (throw "Unsupported CPU architecture: ${targetPlatform.parsed.cpu.name}")
      }
    "
    buildProject llvm llvm-project/llvm

    # Ensure that the built Clang can find the runtime libraries by
    # copying the symlinks from the main wrapper.
    cp -P ${clang}/resource-root/{lib,share} $SWIFT_BUILD_ROOT/llvm/lib/clang/16.0.0/

  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Add appleSwiftCore to the search paths. Adding the whole SDK results in build failures.
    OLD_NIX_SWIFTFLAGS_COMPILE="$NIX_SWIFTFLAGS_COMPILE"
    OLD_NIX_LDFLAGS="$NIX_LDFLAGS"
    export NIX_SWIFTFLAGS_COMPILE=" -I ${appleSwiftCore}/lib/swift"
    export NIX_LDFLAGS+=" -L ${appleSwiftCore}/lib/swift"
  ''
  + ''

    # Some notes:
    # - BOOTSTRAPPING_MODE defaults to OFF in CMake, but is enabled in standard
    #   builds, so we enable it as well. On Darwin, we have to use the system
    #   Swift libs because of ABI-stability, but this may be trouble if the
    #   builder is an older macOS.
    # - Experimental features are OFF by default in CMake, but are enabled in
    #   official builds, so we do the same. (Concurrency is also required in
    #   the stdlib. StringProcessing is often implicitely imported, causing
    #   lots of warnings if missing.)
    # - SWIFT_STDLIB_ENABLE_OBJC_INTEROP is set explicitely because its check
    #   is buggy. (Uses SWIFT_HOST_VARIANT_SDK before initialized.)
    #   Fixed in: https://github.com/apple/swift/commit/84083afef1de5931904d5c815d53856cdb3fb232
    cmakeFlags="
      -GNinja
      -DBOOTSTRAPPING_MODE=BOOTSTRAPPING${lib.optionalString stdenv.hostPlatform.isDarwin "-WITH-HOSTLIBS"}
      -DSWIFT_ENABLE_EXPERIMENTAL_DIFFERENTIABLE_PROGRAMMING=ON
      -DSWIFT_ENABLE_EXPERIMENTAL_CONCURRENCY=ON
      -DSWIFT_ENABLE_EXPERIMENTAL_CXX_INTEROP=ON
      -DSWIFT_ENABLE_EXPERIMENTAL_DISTRIBUTED=ON
      -DSWIFT_ENABLE_EXPERIMENTAL_STRING_PROCESSING=ON
      -DSWIFT_ENABLE_BACKTRACING=ON
      -DSWIFT_ENABLE_EXPERIMENTAL_OBSERVATION=ON
      -DLLVM_DIR=$SWIFT_BUILD_ROOT/llvm/lib/cmake/llvm
      -DClang_DIR=$SWIFT_BUILD_ROOT/llvm/lib/cmake/clang
      -DSWIFT_PATH_TO_CMARK_SOURCE=$SWIFT_SOURCE_ROOT/swift-cmark
      -DSWIFT_PATH_TO_CMARK_BUILD=$SWIFT_BUILD_ROOT/swift-cmark
      -DSWIFT_PATH_TO_LIBDISPATCH_SOURCE=$SWIFT_SOURCE_ROOT/swift-corelibs-libdispatch
      -DSWIFT_PATH_TO_SWIFT_SYNTAX_SOURCE=$SWIFT_SOURCE_ROOT/swift-syntax
      -DSWIFT_PATH_TO_STRING_PROCESSING_SOURCE=$SWIFT_SOURCE_ROOT/swift-experimental-string-processing
      -DSWIFT_INSTALL_COMPONENTS=${lib.concatStringsSep ";" swiftInstallComponents}
      -DSWIFT_STDLIB_ENABLE_OBJC_INTEROP=${if stdenv.hostPlatform.isDarwin then "ON" else "OFF"}
      -DSWIFT_DARWIN_DEPLOYMENT_VERSION_OSX=${deploymentVersion}
    "
    buildProject swift

  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Restore search paths to remove appleSwiftCore.
    export NIX_SWIFTFLAGS_COMPILE="$OLD_NIX_SWIFTFLAGS_COMPILE"
    export NIX_LDFLAGS="$OLD_NIX_LDFLAGS"
  ''
  + ''

    # These are based on flags in `utils/build-script-impl`.
    #
    # LLDB_USE_SYSTEM_DEBUGSERVER=ON disables the debugserver build on Darwin,
    # which requires a special signature.
    #
    # CMAKE_BUILD_WITH_INSTALL_NAME_DIR ensures we don't use rpath on Darwin.
    cmakeFlags="
      -GNinja
      -DLLDB_SWIFTC=$SWIFT_BUILD_ROOT/swift/bin/swiftc
      -DLLDB_SWIFT_LIBS=$SWIFT_BUILD_ROOT/swift/lib/swift
      -DLLVM_DIR=$SWIFT_BUILD_ROOT/llvm/lib/cmake/llvm
      -DClang_DIR=$SWIFT_BUILD_ROOT/llvm/lib/cmake/clang
      -DSwift_DIR=$SWIFT_BUILD_ROOT/swift/lib/cmake/swift
      -DLLDB_ENABLE_CURSES=ON
      -DLLDB_ENABLE_LIBEDIT=ON
      -DLLDB_ENABLE_PYTHON=ON
      -DLLDB_ENABLE_LZMA=OFF
      -DLLDB_ENABLE_LUA=OFF
      -DLLDB_INCLUDE_TESTS=OFF
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
      ${lib.optionalString stdenv.hostPlatform.isDarwin ''
        -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
      ''}
      -DLibEdit_INCLUDE_DIRS=${lib.getInclude libedit}/include
      -DLibEdit_LIBRARIES=${lib.getLib libedit}/lib/libedit${stdenv.hostPlatform.extensions.sharedLibrary}
      -DCURSES_INCLUDE_DIRS=${lib.getInclude ncurses}/include
      -DCURSES_LIBRARIES=${lib.getLib ncurses}/lib/libncurses${stdenv.hostPlatform.extensions.sharedLibrary}
      -DPANEL_LIBRARIES=${lib.getLib ncurses}/lib/libpanel${stdenv.hostPlatform.extensions.sharedLibrary}
    ";
    buildProject lldb llvm-project/lldb

    ${lib.optionalString stdenv.targetPlatform.isDarwin ''
      # Need to do a standalone build of concurrency for Darwin back deployment.
      # Based on: utils/swift_build_support/swift_build_support/products/backdeployconcurrency.py
      cmakeFlags="
        -GNinja
        -DCMAKE_Swift_COMPILER=$SWIFT_BUILD_ROOT/swift/bin/swiftc
        -DSWIFT_PATH_TO_SWIFT_SYNTAX_SOURCE=$SWIFT_SOURCE_ROOT/swift-syntax

        -DTOOLCHAIN_DIR=/var/empty
        -DSWIFT_NATIVE_LLVM_TOOLS_PATH=${stdenv.cc}/bin
        -DSWIFT_NATIVE_CLANG_TOOLS_PATH=${stdenv.cc}/bin
        -DSWIFT_NATIVE_SWIFT_TOOLS_PATH=$SWIFT_BUILD_ROOT/swift/bin

        -DCMAKE_CROSSCOMPILING=ON

        -DBUILD_SWIFT_CONCURRENCY_BACK_DEPLOYMENT_LIBRARIES=ON
        -DSWIFT_INCLUDE_TOOLS=OFF
        -DSWIFT_BUILD_STDLIB_EXTRA_TOOLCHAIN_CONTENT=OFF
        -DSWIFT_BUILD_TEST_SUPPORT_MODULES=OFF
        -DSWIFT_BUILD_STDLIB=OFF
        -DSWIFT_BUILD_DYNAMIC_STDLIB=OFF
        -DSWIFT_BUILD_STATIC_STDLIB=OFF
        -DSWIFT_BUILD_REMOTE_MIRROR=OFF
        -DSWIFT_BUILD_SDK_OVERLAY=OFF
        -DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=OFF
        -DSWIFT_BUILD_STATIC_SDK_OVERLAY=OFF
        -DSWIFT_INCLUDE_TESTS=OFF
        -DSWIFT_BUILD_PERF_TESTSUITE=OFF

        -DSWIFT_HOST_VARIANT_ARCH=${swiftArch}
        -DBUILD_STANDALONE=ON

        -DSWIFT_INSTALL_COMPONENTS=back-deployment

        -DSWIFT_SDKS=${
          {
            "macos" = "OSX";
            "ios" = "IOS";
            #IOS_SIMULATOR
            #TVOS
            #TVOS_SIMULATOR
            #WATCHOS
            #WATCHOS_SIMULATOR
          }
          .${targetPlatform.darwinPlatform}
        }

        -DLLVM_DIR=$SWIFT_BUILD_ROOT/llvm/lib/cmake/llvm

        -DSWIFT_DEST_ROOT=$out
        -DSWIFT_HOST_VARIANT_SDK=OSX

        -DSWIFT_DARWIN_DEPLOYMENT_VERSION_OSX=${deploymentVersion}
        -DSWIFT_DARWIN_DEPLOYMENT_VERSION_IOS=13.0
        -DSWIFT_DARWIN_DEPLOYMENT_VERSION_MACCATALYST=13.0
        -DSWIFT_DARWIN_DEPLOYMENT_VERSION_TVOS=13.0
        -DSWIFT_DARWIN_DEPLOYMENT_VERSION_WATCHOS=6.0
      "

      # This depends on the special Clang build specific to the Swift branch.
      # We also need to call a specific Ninja target.
      export CC=$SWIFT_BUILD_ROOT/llvm/bin/clang
      export CXX=$SWIFT_BUILD_ROOT/llvm/bin/clang++
      ninjaFlags="back-deployment"

      buildProject swift-concurrency-backdeploy swift

      export CC=$NIX_CC/bin/clang
      export CXX=$NIX_CC/bin/clang++
      unset ninjaFlags
    ''}
  '';

  # TODO: ~50 failing tests on x86_64-linux. Other platforms not checked.
  doCheck = false;
  nativeCheckInputs = [ file ];
  # TODO: consider using stress-tester and integration-test.
  checkPhase = ''
    cd $SWIFT_BUILD_ROOT/swift
    checkTarget=check-swift-all
    ninjaCheckPhase
    unset checkTarget
  '';

  installPhase = ''
    # Undo the clang and swift wrapping we did for the build.
    # (This happened via patches to cmake files.)
    cd $SWIFT_BUILD_ROOT
    mv llvm/bin/clang-16{-unwrapped,}
    mv swift/bin/swift-frontend{-unwrapped,}

    mkdir $lib

    # Install clang binaries only. We hide these with the wrapper, so they are
    # for private use by Swift only.
    cd $SWIFT_BUILD_ROOT/llvm
    installTargets=install-clang
    ninjaInstallPhase
    unset installTargets

    # LLDB is also a private install.
    cd $SWIFT_BUILD_ROOT/lldb
    ninjaInstallPhase

    cd $SWIFT_BUILD_ROOT/swift
    ninjaInstallPhase

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      cd $SWIFT_BUILD_ROOT/swift-concurrency-backdeploy
      installTargets=install-back-deployment
      ninjaInstallPhase
      unset installTargets
    ''}

    # Separate $lib output here, because specific logic follows.
    # Only move the dynamic run-time parts, to keep $lib small. Every Swift
    # build will depend on it.
    moveToOutput "lib/swift" "$lib"
    moveToOutput "lib/libswiftDemangle.*" "$lib"

    # This link is here because various tools (swiftpm) check for stdlib
    # relative to the swift compiler. It's fine if this is for build-time
    # stuff, but we should patch all cases were it would end up in an output.
    ln -s $lib/lib/swift $out/lib/swift

    # Swift has a separate resource root from Clang, but locates the Clang
    # resource root via subdir or symlink.
    mv $SWIFT_BUILD_ROOT/llvm/lib/clang/16.0.0 $lib/lib/swift/clang
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    # This is cheesy, but helps the patchelf hook remove /build from RPATH.
    cd $SWIFT_BUILD_ROOT/..
    mv build buildx
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # These libraries need to use the system install name. The official SDK
    # does the same (as opposed to using rpath). Presumably, they are part of
    # the stable ABI. Not using the system libraries at run-time is known to
    # cause ObjC class conflicts and segfaults.
    declare -A systemLibs=(
      [libswiftCore.dylib]=1
      [libswiftDarwin.dylib]=1
      [libswiftSwiftOnoneSupport.dylib]=1
      [libswift_Concurrency.dylib]=1
    )

    for systemLib in "''${!systemLibs[@]}"; do
      install_name_tool -id /usr/lib/swift/$systemLib $lib/${swiftLibSubdir}/$systemLib
    done

    for file in $out/bin/swift-frontend $lib/${swiftLibSubdir}/*.dylib; do
      changeArgs=""
      for dylib in $(otool -L $file | awk '{ print $1 }'); do
        if [[ ''${systemLibs["$(basename $dylib)"]} ]]; then
          changeArgs+=" -change $dylib /usr/lib/swift/$(basename $dylib)"
        elif [[ "$dylib" = */bootstrapping1/* ]]; then
          changeArgs+=" -change $dylib $lib/lib/swift/$(basename $dylib)"
        fi
      done
      if [[ -n "$changeArgs" ]]; then
        install_name_tool $changeArgs $file
      fi
    done

    wrapProgram $out/bin/swift-frontend \
      --prefix PATH : ${lib.makeBinPath [ cctools.libtool ]}

    # Needs to be propagated by the compiler not by its dev output.
    moveToOutput nix-support/propagated-target-target-deps "$out"
  '';

  passthru = {
    inherit
      swiftOs
      swiftArch
      swiftModuleSubdir
      swiftLibSubdir
      swiftStaticModuleSubdir
      swiftStaticLibSubdir
      ;

    tests = {
      cxx-interop-test = callPackage ../cxx-interop-test { };
    };

    # Internal attr for the wrapper.
    _wrapperParams = wrapperParams;
  };

  meta = {
    description = "Swift Programming Language";
    homepage = "https://github.com/apple/swift";
    teams = [ lib.teams.swift ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; linux ++ darwin;
    # Swift doesn't support 32-bit Linux, unknown on other platforms.
    badPlatforms = lib.platforms.i686;
    timeout = 86400; # 24 hours.
  };
}
