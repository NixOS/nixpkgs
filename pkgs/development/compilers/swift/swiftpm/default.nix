{ lib
, stdenv
, callPackage
, fetchpatch
, cmake
, ninja
, git
, swift
, swiftpm2nix
, Foundation
, XCTest
, pkg-config
, sqlite
, ncurses
, substituteAll
, runCommandLocal
, makeWrapper
, DarwinTools # sw_vers
, cctools # vtool
, xcbuild
, CryptoKit
, LocalAuthentication
}:

let

  inherit (swift) swiftOs swiftModuleSubdir swiftStaticModuleSubdir;
  sharedLibraryExt = stdenv.hostPlatform.extensions.sharedLibrary;

  sources = callPackage ../sources.nix { };
  generated = swiftpm2nix.helpers ./generated;
  cmakeGlue = callPackage ./cmake-glue.nix { };

  # Common attributes for the bootstrap swiftpm and the final swiftpm.
  commonAttrs = {
    inherit (sources) version;
    src = sources.swift-package-manager;
    nativeBuildInputs = [ makeWrapper ];
    # Required at run-time for the host platform to build package manifests.
    propagatedBuildInputs = [ Foundation ];
    patches = [
      ./patches/cmake-disable-rpath.patch
      ./patches/cmake-fix-quoting.patch
      ./patches/disable-index-store.patch
      ./patches/disable-sandbox.patch
      ./patches/disable-xctest.patch
      ./patches/fix-clang-cxx.patch
      ./patches/nix-pkgconfig-vars.patch
      (substituteAll {
        src = ./patches/fix-stdlib-path.patch;
        inherit (builtins) storeDir;
        swiftLib = swift.swift.lib;
      })
    ];
    postPatch = ''
      # The location of xcrun is hardcoded. We need PATH lookup instead.
      find Sources -name '*.swift' | xargs sed -i -e 's|/usr/bin/xcrun|xcrun|g'

      # Patch the location where swiftpm looks for its API modules.
      substituteInPlace Sources/PackageModel/UserToolchain.swift \
        --replace \
          'librariesPath = applicationPath.parentDirectory' \
          "librariesPath = AbsolutePath(\"$out\")"

      # Fix case-sensitivity issues.
      # Upstream PR: https://github.com/apple/swift-package-manager/pull/6500
      substituteInPlace Sources/CMakeLists.txt \
        --replace \
          'packageCollectionsSigning' \
          'PackageCollectionsSigning'
      substituteInPlace Sources/PackageCollectionsSigning/CMakeLists.txt \
        --replace \
          'SubjectPublickeyInfo' \
          'SubjectPublicKeyInfo'
      substituteInPlace Sources/PackageCollections/CMakeLists.txt \
        --replace \
          'FilepackageCollectionsSourcesStorage' \
          'FilePackageCollectionsSourcesStorage'
    '';
  };

  # Tools invoked by swiftpm at run-time.
  runtimeDeps = [ git ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      xcbuild.xcrun
      # These tools are part of cctools, but adding that as a build input puts
      # an unwrapped linker in PATH, and breaks builds. This small derivation
      # exposes just the tools we need:
      # - vtool is used to determine a minimum deployment target.
      # - libtool is used to build static libraries.
      (runCommandLocal "swiftpm-cctools" { } ''
        mkdir -p $out/bin
        ln -s ${cctools}/bin/vtool $out/bin/vtool
        ln -s ${cctools}/bin/libtool $out/bin/libtool
      '')
    ];

  # Common attributes for the bootstrap derivations.
  mkBootstrapDerivation = attrs: stdenv.mkDerivation (attrs // {
    nativeBuildInputs = (attrs.nativeBuildInputs or [ ])
      ++ [ cmake ninja swift ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ DarwinTools ];

    buildInputs = (attrs.buildInputs or [ ])
      ++ [ Foundation ];

    postPatch = (attrs.postPatch or "")
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        # On Darwin only, Swift uses arm64 as cpu arch.
        if [ -e cmake/modules/SwiftSupport.cmake ]; then
          substituteInPlace cmake/modules/SwiftSupport.cmake \
            --replace '"aarch64" PARENT_SCOPE' '"arm64" PARENT_SCOPE'
        fi
      '';

    preConfigure = (attrs.preConfigure or "")
      + ''
        # Builds often don't set a target, and our default minimum macOS deployment
        # target on x86_64-darwin is too low. Harmless on non-Darwin.
        export MACOSX_DEPLOYMENT_TARGET=10.15.4
      '';

    postInstall = (attrs.postInstall or "")
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        # The install name of libraries is incorrectly set to lib/ (via our
        # CMake setup hook) instead of lib/swift/. This'd be easily fixed by
        # fixDarwinDylibNames, but some builds create libraries that reference
        # eachother, and we also have to fix those references.
        dylibs="$(find $out/lib/swift* -name '*.dylib')"
        changes=""
        for dylib in $dylibs; do
          changes+=" -change $(otool -D $dylib | tail -n 1) $dylib"
        done
        for dylib in $dylibs; do
          install_name_tool -id $dylib $changes $dylib
        done
      '';

    cmakeFlags = (attrs.cmakeFlags or [ ])
      ++ [
        # Some builds link to libraries within the same build. Make sure these
        # create references to $out. None of our builds run their own products,
        # so we don't have to account for that scenario.
        "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
      ];
  });

  # On Darwin, we only want ncurses in the linker search path, because headers
  # are part of libsystem. Adding its headers to the search path causes strange
  # mixing and errors.
  # TODO: Find a better way to prevent this conflict.
  ncursesInput = if stdenv.hostPlatform.isDarwin then ncurses.out else ncurses;

  # Derivations for bootstrapping dependencies using CMake.
  # This is based on the `swiftpm/Utilities/bootstrap` script.
  #
  # Some of the installation steps here are a bit hacky, because it seems like
  # these packages were not really meant to be installed using CMake. The
  # regular swiftpm bootstrap simply refers to the source and build
  # directories. The advantage of separate builds is that we can more easily
  # link libs together using existing Nixpkgs infra.
  #
  # In the end, we don't expose these derivations, and they only exist during
  # the bootstrap phase. The final swiftpm derivation does not depend on them.

  swift-system = mkBootstrapDerivation {
    name = "swift-system";
    src = generated.sources.swift-system;

    postInstall = cmakeGlue.SwiftSystem
      + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
        # The cmake rules apparently only use the Darwin install convention.
        # Fix up the installation so the module can be found on non-Darwin.
        mkdir -p $out/${swiftStaticModuleSubdir}
        mv $out/lib/swift_static/${swiftOs}/*.swiftmodule $out/${swiftStaticModuleSubdir}/
      '';
  };

  swift-collections = mkBootstrapDerivation {
    name = "swift-collections";
    src = generated.sources.swift-collections;

    postPatch = ''
      # Only builds static libs on Linux, but this installation difference is a
      # hassle. Because this installation is temporary for the bootstrap, may
      # as well build static libs everywhere.
      sed -i -e '/BUILD_SHARED_LIBS/d' CMakeLists.txt
    '';

    postInstall = cmakeGlue.SwiftCollections
      + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
        # The cmake rules apparently only use the Darwin install convention.
        # Fix up the installation so the module can be found on non-Darwin.
        mkdir -p $out/${swiftStaticModuleSubdir}
        mv $out/lib/swift_static/${swiftOs}/*.swiftmodule $out/${swiftStaticModuleSubdir}/
      '';
  };

  # Part of this patch fixes for glibc 2.39: glibc patch 64b1a44183a3094672ed304532bedb9acc707554
  # marks the `FILE*` argument to a few functions including `ferror` & `fread` as non-null. However
  # the code passes an `Optional<T>` to these functions.
  # This patch uses a `guard` which effectively unwraps the type (or throws an exception).
  swift-tools-support-core-glibc-fix = fetchpatch {
    url = "https://github.com/apple/swift-tools-support-core/commit/990afca47e75cce136d2f59e464577e68a164035.patch";
    hash = "sha256-PLzWsp+syiUBHhEFS8+WyUcSae5p0Lhk7SSRdNvfouE=";
    includes = [ "Sources/TSCBasic/FileSystem.swift" ];
  };

  swift-tools-support-core = mkBootstrapDerivation {
    name = "swift-tools-support-core";
    src = generated.sources.swift-tools-support-core;

    patches = [
      swift-tools-support-core-glibc-fix
    ];

    buildInputs = [
      swift-system
      sqlite
    ];

    postInstall = cmakeGlue.TSC + ''
      # Swift modules are not installed.
      mkdir -p $out/${swiftModuleSubdir}
      cp swift/*.swift{module,doc} $out/${swiftModuleSubdir}/

      # Static libs are not installed.
      cp lib/*.a $out/lib/

      # Headers are not installed.
      mkdir -p $out/include
      cp -r ../Sources/TSCclibc/include $out/include/TSC
    '';
  };

  swift-argument-parser = mkBootstrapDerivation {
    name = "swift-argument-parser";
    src = generated.sources.swift-argument-parser;

    buildInputs = [ ncursesInput sqlite ];

    cmakeFlags = [
      "-DBUILD_TESTING=NO"
      "-DBUILD_EXAMPLES=NO"
    ];

    postInstall = cmakeGlue.ArgumentParser
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        # Fix rpath so ArgumentParserToolInfo can be found.
        patchelf --add-rpath "$out/lib/swift/${swiftOs}" \
          $out/lib/swift/${swiftOs}/libArgumentParser.so
      '';
  };

  Yams = mkBootstrapDerivation {
    name = "Yams";
    src = generated.sources.Yams;

    # Conflicts with BUILD file on case-insensitive filesystems.
    cmakeBuildDir = "_build";

    postInstall = cmakeGlue.Yams;
  };

  llbuild = mkBootstrapDerivation {
    name = "llbuild";
    src = generated.sources.swift-llbuild;

    nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin xcbuild;
    buildInputs = [ ncursesInput sqlite ];

    patches = [
      ./patches/llbuild-cmake-disable-rpath.patch
    ];

    postPatch = ''
      # Substitute ncurses for curses.
      find . -name CMakeLists.txt | xargs sed -i -e 's/curses/ncurses/'

      # Use absolute install names instead of rpath.
      substituteInPlace \
        products/libllbuild/CMakeLists.txt \
        products/llbuildSwift/CMakeLists.txt \
        --replace '@rpath' "$out/lib"

      # This subdirectory is enabled for Darwin only, but requires ObjC XCTest
      # (and only Swift XCTest is open source).
      substituteInPlace perftests/CMakeLists.txt \
        --replace 'add_subdirectory(Xcode/' '#add_subdirectory(Xcode/'
    '';

    cmakeFlags = [
      "-DLLBUILD_SUPPORT_BINDINGS=Swift"
    ];

    postInstall = cmakeGlue.LLBuild + ''
      # Install module map.
      cp ../products/libllbuild/include/module.modulemap $out/include

      # Swift modules are not installed.
      mkdir -p $out/${swiftModuleSubdir}
      cp products/llbuildSwift/*.swift{module,doc} $out/${swiftModuleSubdir}/
    '';
  };

  swift-driver = mkBootstrapDerivation {
    name = "swift-driver";
    src = generated.sources.swift-driver;

    buildInputs = [
      Yams
      llbuild
      swift-system
      swift-argument-parser
      swift-tools-support-core
    ];

    postPatch = ''
      # Tries to link against CYaml, but that's private.
      substituteInPlace Sources/SwiftDriver/CMakeLists.txt \
        --replace CYaml ""
    '';

    postInstall = cmakeGlue.SwiftDriver + ''
      # Swift modules are not installed.
      mkdir -p $out/${swiftModuleSubdir}
      cp swift/*.swift{module,doc} $out/${swiftModuleSubdir}/
    '';
  };

  swift-crypto = mkBootstrapDerivation {
    name = "swift-crypto";
    src = generated.sources.swift-crypto;

    postPatch = ''
      # Fix use of hardcoded tool paths on Darwin.
      substituteInPlace CMakeLists.txt \
        --replace /usr/bin/ar $NIX_CC/bin/ar
      substituteInPlace CMakeLists.txt \
        --replace /usr/bin/ranlib $NIX_CC/bin/ranlib
    '';

    postInstall = cmakeGlue.SwiftCrypto + ''
      # Static libs are not installed.
      cp lib/*.a $out/lib/

      # Headers are not installed.
      cp -r ../Sources/CCryptoBoringSSL/include $out/include
    '';
  };

  # Build a bootrapping swiftpm using CMake.
  swiftpm-bootstrap = mkBootstrapDerivation (commonAttrs // {
    pname = "swiftpm-bootstrap";

    buildInputs = [
      llbuild
      sqlite
      swift-argument-parser
      swift-collections
      swift-crypto
      swift-driver
      swift-system
      swift-tools-support-core
    ];

    cmakeFlags = [
      "-DUSE_CMAKE_INSTALL=ON"
    ];

    postInstall = ''
      for program in $out/bin/swift-*; do
        wrapProgram $program --prefix PATH : ${lib.makeBinPath runtimeDeps}
      done
    '';
  });

# Build the final swiftpm with the bootstrapping swiftpm.
in stdenv.mkDerivation (commonAttrs // {
  pname = "swiftpm";

  nativeBuildInputs = commonAttrs.nativeBuildInputs ++ [
    pkg-config
    swift
    swiftpm-bootstrap
  ];
  buildInputs = [
    ncursesInput
    sqlite
    XCTest
  ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      CryptoKit
      LocalAuthentication
    ];

  configurePhase = generated.configure + ''
    # Functionality provided by Xcode XCTest, but not available in
    # swift-corelibs-xctest.
    swiftpmMakeMutable swift-tools-support-core
    substituteInPlace .build/checkouts/swift-tools-support-core/Sources/TSCTestSupport/XCTestCasePerf.swift \
      --replace 'canImport(Darwin)' 'false'
    patch -p1 -d .build/checkouts/swift-tools-support-core -i ${swift-tools-support-core-glibc-fix}

    # Prevent a warning about SDK directories we don't have.
    swiftpmMakeMutable swift-driver
    patch -p1 -d .build/checkouts/swift-driver -i ${substituteAll {
      src = ../swift-driver/patches/prevent-sdk-dirs-warnings.patch;
      inherit (builtins) storeDir;
    }}
  '';

  buildPhase = ''
    # Required to link with swift-corelibs-xctest on Darwin.
    export SWIFTTSC_MACOS_DEPLOYMENT_TARGET=10.12

    TERM=dumb swift-build -c release
  '';

  # TODO: Tests depend on indexstore-db being provided by an existing Swift
  # toolchain. (ie. looks for `../lib/libIndexStore.so` relative to swiftc.
  #doCheck = true;
  #checkPhase = ''
  #  TERM=dumb swift-test -c release
  #'';

  # The following is dervied from Utilities/bootstrap, see install_swiftpm.
  installPhase = ''
    binPath="$(swift-build --show-bin-path -c release)"

    mkdir -p $out/bin $out/lib/swift

    cp $binPath/swift-package-manager $out/bin/swift-package
    wrapProgram $out/bin/swift-package \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
    for tool in swift-build swift-test swift-run swift-package-collection swift-experimental-destination; do
      ln -s $out/bin/swift-package $out/bin/$tool
    done

    installSwiftpmModule() {
      mkdir -p $out/lib/swift/pm/$2
      cp $binPath/lib$1${sharedLibraryExt} $out/lib/swift/pm/$2/

      if [[ -f $binPath/$1.swiftinterface ]]; then
        cp $binPath/$1.swiftinterface $out/lib/swift/pm/$2/
      else
        cp -r $binPath/$1.swiftmodule $out/lib/swift/pm/$2/
      fi
      cp $binPath/$1.swiftdoc $out/lib/swift/pm/$2/
    }
    installSwiftpmModule PackageDescription ManifestAPI
    installSwiftpmModule PackagePlugin PluginAPI
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Package Manager for the Swift Programming Language";
    homepage = "https://github.com/apple/swift-package-manager";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
    maintainers = lib.teams.swift.members;
  };
})
