{
  lib,
  cmake,
  fetchFromGitHub,
  fixDarwinDylibNames,
  ncurses,
  ninja,
  sqlite,
  stdenv,
  swift-corelibs-libdispatch,
  swift-foundation,
  swift-minimal,
  swift_release,
  swift_sources,
}:

let
  swiftPlatform = stdenv.hostPlatform.swift.platform;
  # swift-llbuild requires Foundation and Dispatch.
  swift = swift-minimal.override { inherit swift-corelibs-libdispatch swift-foundation; };
in

# LLBuild is a dependency to both Swift Compiler Driver and SwiftPM.
# It must be built with CMake and use Swift without swift-driver to avoid dependency cycles.
stdenv.mkDerivation (finalAttrs: {
  pname = "swift-llbuild";
  version = swift_release;

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-llbuild";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.swift-llbuild) hash;
  };

  patches = [ ./patches/0001-gnu-install-dirs.patch ];

  postPatch = ''
    # Disable performance tests, which require XCTest.framework. XCTest.framework is not available.
    substituteInPlace CMakeLists.txt --replace-fail 'add_subdirectory(perftests)' ""

    # Disable building the framework on Darwin, which we don’t use.
    substituteInPlace products/libllbuild/CMakeLists.txt \
      --replace-fail 'if(''${CMAKE_SYSTEM_NAME} MATCHES "Darwin")' "if(FALSE)"

    # Use ncurses instead of curses
    grep -rl 'curses)' -Z | while IFS= read -d "" file; do
      substituteInPlace "$file" --replace-fail 'curses)' 'ncurses)'
    done
  '';

  strictDeps = true;

  cmakeFlags = [
    # Defaults to not building shared libs.
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    # Swift bindings are needed to build swift-driver.
    (lib.cmakeFeature "LLBUILD_SUPPORT_BINDINGS" "Swift")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Defaults to the `buildPlatform` architecture if this is not set.
    (lib.cmakeFeature "CMAKE_OSX_ARCHITECTURES" stdenv.hostPlatform.darwinArch)
  ];

  preConfigure = ''
    appendToVar cmakeFlags -DCMAKE_Swift_COMPILER_TARGET=${stdenv.hostPlatform.swift.triple}
    appendToVar cmakeFlags -DCMAKE_Swift_FLAGS=-module-cache-path\ "$NIX_BUILD_TOP/module-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    swift
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  buildInputs = [
    ncurses
    sqlite
  ];

  postInstall = ''
    # Install the module map for the `llbuild` module.
    mkdir -p "''${!outputDev}/include"
    cp -v "$NIX_BUILD_TOP/$sourceRoot/products/libllbuild/include/module.modulemap" "''${!outputDev}/include"

    # Install the swiftmodule (needed to use `llbuildSwift`).
    mkdir -p "''${!outputDev}/lib/swift/${swiftPlatform}"
    cp -v products/llbuildSwift/llbuildSwift.swiftmodule "''${!outputDev}/lib/swift/${swiftPlatform}"

    # Install CMake config file for llbuild and llbuildSwift.
    mkdir -p "''${!outputDev}/lib/cmake/LLBuild"
    substitute ${./files/LLBuildConfig.cmake} "''${!outputDev}/lib/cmake/LLBuild/LLBuildConfig.cmake" \
      --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
      --replace-fail '@dev@' "''${!outputDev}" \
      --replace-fail '@lib@' "''${!outputLib}" \
      --replace-fail '@swiftPlatform@' ${swiftPlatform}
  '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/swiftlang/swift-llbuild";
    description = "Low-level build system used by SwiftPM and Xcode";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
