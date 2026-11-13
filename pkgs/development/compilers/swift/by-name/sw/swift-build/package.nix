{
  lib,
  bashNonInteractive,
  cmake,
  coreutils,
  cctools,
  darwin,
  diffutils,
  fetchFromGitHub,
  gnumake,
  gnused,
  iconv,
  libtapi,
  llvmPackages,
  ninja,
  re-derq,
  replaceVars,
  sqlite,
  stdenv,
  swift,
  swift-argument-parser,
  swift-corelibs-xctest,
  swift-driver,
  swift-llbuild,
  swift-system,
  swift-tools-protocols,
  swift-tools-support-core,
  what,
  xcbuild,
  swift_release,
  swift_sources,
}:

let
  swiftPlatform = stdenv.hostPlatform.swift.platform;

  swift' = swift.override {
    enableRepl = false;
    enableSourceKitLSP = false;
  };

  # FIXME: Drop once `darwin.sigtool` has a new release.
  sigtool = darwin.sigtool.overrideAttrs (old: {
    version = "0.2.2-unstable-2026-10-14";
    src = fetchFromGitHub {
      owner = "nix-community";
      repo = "sigtool";
      rev = "de5de43c5f8bd97bce4de4a8cfc1b3708074a2b2";
      hash = "sha256-VWe+SPQqDPtrAIZf1k6w5Eg4+ofAxlhr/qYCDxvpfOA=";
    };
    patches = [ ./0001-Add-cstdint-header-for-GCC-16.patch ];
    # FIXME: `codesign_allocate` should probably be split into its own package for portability purposes.
    postPatch =
      (old.postPatch or "")
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        substituteInPlace commands.cpp \
          --replace-fail 'codesign_allocate = "codesign_allocate";' 'codesign_allocate = "${cctools}/bin/codesign_allocate";'
      '';
  });
in

# Swift Build is a dependency of SwiftPM. It must be built with CMake to avoid dependency cycles.
stdenv.mkDerivation (finalAttrs: {
  pname = "swift-build";
  version = swift_release;

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-build";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.swift-build) hash;
  };

  patches = [
    # Remove as many impure paths as possible.
    (replaceVars ./patches/0001-replace-impure-paths.patch {
      inherit (darwin) graphics_cmds;
      inherit (llvmPackages) llvm;
      inherit (xcbuild) xcrun;
      inherit bashNonInteractive;
      inherit coreutils;
      inherit diffutils;
      inherit gnumake;
      inherit gnused;
      inherit iconv;
      inherit re-derq;
      inherit sigtool;
      inherit what;
      tapi = lib.getBin libtapi;
    })
    # Swift Build checks whether the SDK is Xcode by looking at the `DEVELOPER_DIR` path for Xcode.
    # Have it treat store paths as being Xcode SDKs so that the nixpkgs SDK is treated as a Darwin platform.
    (replaceVars ./patches/0002-treat-nixpkgs-sdk-as-xcode.patch {
      store-dir = builtins.storeDir;
    })
    # Don’t look in the build directory for bundles. Look only in the store.
    ./patches/0003-find-bundles-in-store.patch
    # Swift Build makes assumptions about the layout of the toolchain (e.g., that paths begin with `usr`) that
    # are not true for the toolchain Nixpkgs.
    (replaceVars ./patches/0004-Help-Swift-Build-find-things-in-the-store.patch {
      store-dir = builtins.storeDir;
    })
    # Swift Build expects to find the testing macros in the toolchain path starting at `usr/lib/swift/host/testing`,
    # but the Nixpkgs toolchain installs them to `lib/swift/host/testing`.
    ./patches/0005-Locate-Swift-Testing-macros-in-the-Nixpkgs-toolchain.patch
    # We don’t have the XCTest frameworks from Xcode on Darwin, so link against what we do have.
    (replaceVars ./patches/0006-Link-against-XCTest-from-swift-corelibs-xctest-even-.patch {
      inherit swift-corelibs-xctest;
    })
  ];

  # FIXME: Make this a patch
  postPatch = ''
    # Allow Swift Build to find `SWBBuildServiceBundle` in `$out/libexec`.
    substituteInPlace Sources/SwiftBuild/SWBBuildServiceConnection.swift \
      --replace-fail 'Bundle(for: SWBBuildServiceConnection.self).bundleURL.deletingLastPathComponent()' 'URL(filePath: "@lib@/libexec")' \
      --replace-fail 'Bundle.main.executableURL?.deletingLastPathComponent()' '.some(URL(filePath: "@lib@/libexec"))?' \
      --replace-fail '@lib@' "''${!outputLib}"

    # Use the path to `swift` to find the plugin server binary
    substituteInPlace Sources/SWBCore/Settings/Settings.swift \
      --replace-fail '\(toolchain.path.str)/usr/bin/swift-plugin-server' ${lib.getExe' swift.swiftc "swift-plugin-server"}
  '';

  strictDeps = true;

  cmakeFlags = [
    # The CMake hook doesn’t set `${CMAKE_INSTALL_DATADIR}` to a store path, so it needs to be specified manually.
    (lib.cmakeFeature "CMAKE_INSTALL_DATADIR" "${placeholder "lib"}/share")
  ];

  preConfigure = ''
    appendToVar cmakeFlags -DCMAKE_Swift_COMPILER_TARGET=${stdenv.hostPlatform.swift.triple}
    appendToVar cmakeFlags -DCMAKE_Swift_FLAGS=-module-cache-path\ "$NIX_BUILD_TOP/module-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    swift'
  ];

  buildInputs = [
    sqlite
    swift-argument-parser
    swift-driver
    swift-llbuild
    swift-tools-protocols
    swift-system
    swift-tools-support-core
  ];

  # Needed for `fixDarwinDylibNames` to work.
  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-headerpad_max_install_names";

  postInstall = ''
    mkdir -p "''${!outputLib}/libexec"
    mv "''${!outputBin}/bin/SWBBuildServiceBundle" "''${!outputLib}/libexec/SWBBuildServiceBundle"

    # Install the swiftmodules.
    mkdir -p "''${!outputDev}/lib/swift/${swiftPlatform}"
    cp -v swift/*.swiftmodule "''${!outputDev}/lib/swift/${swiftPlatform}"

    # Install the C module
    mkdir -p "''${!outputDev}/include"
    cp -v "$NIX_BUILD_TOP/$sourceRoot/Sources/SWBCLibc/include"/*.h "''${!outputDev}/include"
    cp -v "$NIX_BUILD_TOP/$sourceRoot/Sources/SWBCSupport"/*.h "''${!outputDev}/include"
    cat \
      "$NIX_BUILD_TOP/$sourceRoot/Sources/SWBCLibc/include/module.modulemap" \
      "$NIX_BUILD_TOP/$sourceRoot/Sources/SWBCSupport/module.modulemap" \
      > "''${!outputDev}/include/module.modulemap"

    # Install CMake config file for the Swift Build library.
    mkdir -p "''${!outputDev}/lib/cmake/SwiftBuild"
    substitute ${./files/SwiftBuildConfig.cmake} "''${!outputDev}/lib/cmake/SwiftBuild/SwiftBuildConfig.cmake" \
      --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
      --replace-fail '@include@' "''${!outputDev}" \
      --replace-fail '@lib@' "''${!outputLib}" \
      --replace-fail '@swiftPlatform@' ${swiftPlatform}
  '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/swiftlang/swift-build";
    description = "High-level build system based on llbuild";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
