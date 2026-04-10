{
  lib,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  ninja,
  stdenv,
  swift,
  swift-asn1,
  swift-crypto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-certificates";
  version = "1.19.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "apple";
    repo = "swift-certificates";
    tag = finalAttrs.version;
    hash = "sha256-8I7/JAcGYrk22DymtlM2aiFXlQc3OijBAGL3DtoJWTE=";
  };

  postPatch = ''
    substituteInPlace cmake/modules/SwiftSupport.cmake \
      --replace-fail 'ARCHIVE DESTINATION lib/''${swift}/''${swift_os}' 'ARCHIVE DESTINATION ''${CMAKE_INSTALL_LIBDIR}' \
      --replace-fail 'LIBRARY DESTINATION lib/''${swift}/''${swift_os}' 'LIBRARY DESTINATION ''${CMAKE_INSTALL_LIBDIR}' \
      --replace-fail 'RUNTIME DESTINATION bin' 'RUNTIME DESTINATION ''${CMAKE_INSTALL_BINDIR}' \
      --replace-fail '    DESTINATION lib' "DESTINATION ''${!outputInclude}/lib"
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

  buildInputs = [
    swift-asn1
    swift-crypto
  ];

  postInstall = ''
    # Install CMake config file for the Swift Certificates library.
    mkdir -p "''${!outputDev}/lib/cmake/SwiftCertificates"
    substitute ${./files/SwiftCertificatesConfig.cmake} "''${!outputDev}/lib/cmake/SwiftCertificates/SwiftCertificatesConfig.cmake" \
      --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
      --replace-fail '@include@' "''${!outputDev}" \
      --replace-fail '@lib@' "''${!outputLib}" \
      --replace-fail '@swiftPlatform@' ${stdenv.hostPlatform.swift.platform}
  '';

  passthru.updateScript = gitUpdater { };

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/apple/swift-certificates";
    description = "An implementation of X.509 for Swift";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
