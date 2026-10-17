{
  lib,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  ninja,
  stdenv,
  swift,
}:

# Swift-ASN1 is a dependency of SwiftPM. It must be built with CMake to avoid dependency cycles.
stdenv.mkDerivation (finalAttrs: {
  pname = "swift-asn1";
  version = "1.7.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "apple";
    repo = "swift-asn1";
    tag = finalAttrs.version;
    hash = "sha256-hikWOlKKW0VplBuDgrt/Xyao3gsDS5IkxsMfbITHT2I=";
  };

  postPatch = ''
    substituteInPlace cmake/modules/SwiftSupport.cmake \
      --replace-fail 'ARCHIVE DESTINATION lib/''${swift}/''${swift_os}' 'ARCHIVE DESTINATION ''${CMAKE_INSTALL_LIBDIR}' \
      --replace-fail 'LIBRARY DESTINATION lib/''${swift}/''${swift_os}' 'LIBRARY DESTINATION ''${CMAKE_INSTALL_LIBDIR}' \
      --replace-fail 'RUNTIME DESTINATION bin' 'RUNTIME DESTINATION ''${CMAKE_INSTALL_BINDIR}'
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
  ];

  postInstall = ''
    moveToOutput lib/swift "''${!outputDev}"
    moveToOutput lib/swift_static "''${!outputDev}"

    # Install CMake config file for the SwiftASN1 library.
    mkdir -p "''${!outputDev}/lib/cmake/SwiftASN1"
    substitute ${./files/SwiftASN1Config.cmake} "''${!outputDev}/lib/cmake/SwiftASN1/SwiftASN1Config.cmake" \
      --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
      --replace-fail '@include@' "''${!outputDev}" \
      --replace-fail '@lib@' "''${!outputLib}" \
      --replace-fail '@swiftPlatform@' ${stdenv.hostPlatform.swift.platform}
  '';

  passthru.updateScript = gitUpdater { };

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/apple/swift-asn1";
    description = "An implementation of ASN.1 for Swift";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
