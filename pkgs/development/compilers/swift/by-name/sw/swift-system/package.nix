{
  lib,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  ninja,
  stdenv,
  swift,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-system";
  version = "1.8.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "apple";
    repo = "swift-system";
    tag = finalAttrs.version;
    hash = "sha256-mnQcCHYW0oCadmIE9ayjs3aZiCVQRuliQ0qWpQ22OFQ=";
  };

  patches = [ ./patches/0001-gnu-install-dirs.patch ];

  strictDeps = true;

  preConfigure = ''
    appendToVar cmakeFlags -DCMAKE_Swift_COMPILER_TARGET=${stdenv.hostPlatform.swift.triple}
    appendToVar cmakeFlags -DCMAKE_Swift_FLAGS=-module-cache-path\ "$NIX_BUILD_TOP/module-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    swift
  ];

  postInstall = ''
    moveToOutput lib/swift "''${!outputDev}"
    moveToOutput lib/swift_static "''${!outputDev}"

    # This isn’t installed by the upstream CMake files, but it’s needed.
    cp lib/libCSystem.a "$out/lib/libCSystem.a"

    # Install CMake config file for Swift System.
    mkdir -p "''${!outputDev}/lib/cmake/SwiftSystem"
    substitute ${./files/SwiftSystemConfig.cmake} "''${!outputDev}/lib/cmake/SwiftSystem/SwiftSystemConfig.cmake" \
      --replace-fail '@dev@' "''${!outputDev}" \
      --replace-fail '@lib@' "''${!outputLib}" \
      --replace-fail '@swiftPlatform@' ${stdenv.hostPlatform.swift.platform}
  '';

  __structuredAttrs = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/apple/swift-system";
    description = "Low-level APIs and types for Swift";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
