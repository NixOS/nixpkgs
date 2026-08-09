{
  lib,
  cmake,
  coreutils,
  darwin,
  diffutils,
  fetchFromGitHub,
  gnused,
  libiconv,
  libtiff,
  llvmPackages_upstream,
  llvm_libtool,
  ninja,
  oxipng,
  replaceVars,
  sqlite,
  stdenv,
  stdenvNoCC,
  swift,
  swift-argument-parser,
  swift-driver,
  swift-llbuild,
  swift-system,
  swift-tools-support-core,
  xcbuild,
  swift_release,
  swift_sources,
}:

let
  graphics_cmds = stdenvNoCC.mkDerivation {
    pname = "graphics_cmds";
    version = "1";

    buildCommand = ''
      install -m755 -D ${
        replaceVars ./extra-bins/copypng { inherit coreutils oxipng; }
      } "$out/bin/copypng"
      install -m755 -D ${replaceVars ./extra-bins/tiffutil { inherit libtiff; }} "$out/bin/tiffutil"
    '';
  };

  swiftPlatform = stdenv.hostPlatform.swift.platform;
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
      xcrun = if stdenv.hostPlatform.isDarwin then xcbuild.xcrun else "/not-supported";
      inherit graphics_cmds;
      coreutils = lib.getBin coreutils;
      diffutils = lib.getBin diffutils;
      gnused = lib.getBin gnused;
      libiconv = lib.getBin libiconv;
      libtool = lib.getBin llvm_libtool;
      llvm = lib.getBin llvmPackages_upstream.llvm;
      shell_cmds =
        if stdenv.hostPlatform.isDarwin then lib.getBin darwin.shell_cmds else "/not-supported";
      sigtool = lib.getBin darwin.sigtool;
    })
    # Swift Build checks whether the SDK is Xcode by looking at the `DEVELOPER_DIR` path for Xcode.
    # Have it treat store paths as being Xcode SDKs so that the nixpkgs SDK is treated as a Darwin platform.
    (replaceVars ./patches/0002-treat-nixpkgs-sdk-as-xcode.patch {
      store-dir = builtins.storeDir;
    })
    # Don’t look in the build directory for bundles. Look only in the store.
    ./patches/0003-find-bundles-in-store.patch
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
    swift
  ];

  buildInputs = [
    sqlite
    swift-argument-parser
    swift-driver
    swift-llbuild
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
