{
  lib,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  ninja,
  stdenv,
  swift,
  swift-asn1,
}:

let
  swiftPlatform = stdenv.hostPlatform.swift.platform;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-crypto";
  version = "4.5.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "apple";
    repo = "swift-crypto";
    tag = finalAttrs.version;
    hash = "sha256-RLZmCrRmu6ZYre+VT4YzxpM8LgM7lLCbcMD/CVPiRTg=";
  };

  patches = [
    # Install _CryptoExtras and CryptoBoringWrapper
    ./patches/0001-install-missing-modules.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '/usr/bin/ar' '$ENV{AR}' \
      --replace-fail '/usr/bin/ranlib' '$ENV{RANLIB}'

    substituteInPlace cmake/modules/SwiftSupport.cmake \
      --replace-fail 'ARCHIVE DESTINATION lib/''${swift}/''${swift_os}' 'ARCHIVE DESTINATION ''${CMAKE_INSTALL_LIBDIR}' \
      --replace-fail 'LIBRARY DESTINATION lib/''${swift}/''${swift_os}' 'LIBRARY DESTINATION ''${CMAKE_INSTALL_LIBDIR}' \
      --replace-fail 'RUNTIME DESTINATION bin' 'RUNTIME DESTINATION ''${CMAKE_INSTALL_BINDIR}' \
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

  buildInputs = [ (lib.getInclude swift-asn1) ];

  postInstall = ''
    moveToOutput lib/swift "''${!outputDev}"
    moveToOutput lib/swift_static "''${!outputDev}"

    # Install CMake config file for the Swift Crypto library.
    mkdir -p "''${!outputDev}/lib/cmake/SwiftCrypto"
    substitute ${./files/SwiftCryptoConfig.cmake} "''${!outputDev}/lib/cmake/SwiftCrypto/SwiftCryptoConfig.cmake" \
      --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
      --replace-fail '@include@' "''${!outputDev}" \
      --replace-fail '@lib@' "''${!outputLib}" \
      --replace-fail '@swiftPlatform@' ${swiftPlatform}
  '';

  __structuredAttrs = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/apple/swift-crypto";
    description = "Open-source implementation of most of CryptoKit for Swift";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
