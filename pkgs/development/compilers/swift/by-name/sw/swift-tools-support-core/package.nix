{
  lib,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  llvm_libtool,
  ninja,
  stdenv,
  swift-corelibs-libdispatch,
  swift-foundation,
  swift-minimal,
  swift_release,
  swift_sources,
}:

let
  swiftPlatform = stdenv.hostPlatform.swift.platform;
  # Swift Tools Support Core requires Dispatch and Foundation.
  swift = swift-minimal.override { inherit swift-corelibs-libdispatch swift-foundation; };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-tools-support-core";
  version = swift_release;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-tools-support-core";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.swift-tools-support-core) hash;
  };

  patches = [
    # Match the dynamic library structure of the SwiftPM build when using CMake.
    ./patches/0001-build-SwiftToolsSupport.patch
  ];

  postPatch = ''
    # Disable using XCTest framework properties that aren’t provided by swift-corelibs-xctest.
    substituteInPlace "Sources/TSCTestSupport/XCTestCasePerf.swift" \
      --replace-fail '#if canImport(Darwin)' '#if false'
  '';

  strictDeps = true;

  preConfigure = ''
    appendToVar cmakeFlags -DCMAKE_Swift_COMPILER_TARGET=${stdenv.hostPlatform.swift.triple}
    appendToVar cmakeFlags -DCMAKE_Swift_FLAGS=-module-cache-path\ "$NIX_BUILD_TOP/module-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    swift
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvm_libtool ];

  postInstall = ''
    # Install the swiftmodule.
    mkdir -p "''${!outputDev}/lib/swift/${swiftPlatform}"
    cp -v swift/*.swiftmodule "''${!outputDev}/lib/swift/${swiftPlatform}"

    # Install the C module
    mkdir -p "''${!outputDev}/include"
    cp -v ../Sources/TSCclibc/include/* "''${!outputDev}/include"

    # Install CMake config file for the SwiftSupportTools library.
    mkdir -p "''${!outputDev}/lib/cmake/TSC"
    substitute ${./files/TSCConfig.cmake} "''${!outputDev}/lib/cmake/TSC/TSCConfig.cmake" \
      --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
      --replace-fail '@dev@' "''${!outputDev}" \
      --replace-fail '@lib@' "''${!outputLib}" \
      --replace-fail '@swiftPlatform@' ${swiftPlatform}
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    libExt=${stdenv.hostPlatform.extensions.staticLibrary}
    # These are not linked into the shared library and are linked separate only Linux.
    for libName in TSCBasic TSCLibc; do
      cp -v lib/lib$libName$libExt "''${!outputLib}/lib/lib$libName$libExt"
    done
  '';

  __structuredAttrs = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/swiftlang/swift-tools-support-core";
    description = "Common infrastructure code used by SwiftPM and llbuild";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
