{
  lib,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  ninja,
  stdenv,
  swift-minimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-collections";
  version = "1.6.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "apple";
    repo = "swift-collections";
    tag = finalAttrs.version;
    hash = "sha256-oLYfOxB4CGH5tTkNOi0IX3iHTO64YBoaFyu+/1I5HNE=";
  };

  postPatch = ''
    substituteInPlace cmake/modules/SwiftSupport.cmake \
      --replace-fail '    DESTINATION lib' "DESTINATION ''${!outputDev}/lib" \
      --replace-fail 'lib/''${swift}/''${COLLECTIONS_PLATFORM}$<$<BOOL:''${COLLECTIONS_INSTALL_ARCH_SUBDIR}>:/''${COLLECTIONS_ARCH}>' \''${CMAKE_INSTALL_LIBDIR}
  '';

  strictDeps = true;

  cmakeFlags = [
    # Defaults to not building shared libs on Linux.
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  preConfigure = ''
    appendToVar cmakeFlags -DCMAKE_Swift_COMPILER_TARGET=${stdenv.hostPlatform.swift.triple}
    appendToVar cmakeFlags -DCMAKE_Swift_FLAGS=-module-cache-path\ "$NIX_BUILD_TOP/module-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    swift-minimal
  ];

  postInstall = ''
    moveToOutput lib/swift "''${!outputDev}"
    moveToOutput lib/swift_static "''${!outputDev}"

    # Install CMake config file for the Swift Collections library.
    mkdir -p "''${!outputDev}/lib/cmake/SwiftCollections"
    substitute ${./files/SwiftCollectionsConfig.cmake} "''${!outputDev}/lib/cmake/SwiftCollections/SwiftCollectionsConfig.cmake" \
      --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
      --replace-fail '@include@' "''${!outputDev}" \
      --replace-fail '@lib@' "''${!outputLib}" \
      --replace-fail '@swiftPlatform@' ${stdenv.hostPlatform.swift.platform}
  '';

  __structuredAttrs = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/apple/swift-collections";
    description = "Commonly used data structures for Swift";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
