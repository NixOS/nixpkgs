{
  lib,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  llvm_libtool,
  ninja,
  stdenv,
  swift,
  swift_sources,
}:

let
  swiftPlatform = stdenv.hostPlatform.swift.platform;
in

# The version of swift-tools-protocols comes from Swift’s `update_checkout` script. It is unfortunately not tagged
# using the `swift-<version>-RELEASE` convention other toolchain dependencies use.
# See: https://github.com/swiftlang/swift/blob/main/utils/update_checkout/update-checkout-config.json
stdenv.mkDerivation (finalAttrs: {
  pname = "swift-tools-protocols";
  inherit (swift_sources.swift-tools-protocols) version;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-tools-protocols";
    tag = swift_sources.swift-tools-protocols.version;
    inherit (swift_sources.swift-tools-protocols) hash;
  };

  strictDeps = true;

  cmakeFlags = [
    # Build a shared library to avoid warnings that `_TtC31LanguageServerProtocolTransport17JSONRPCConnection`
    # is implemented in both Swift Build and SwiftPM.
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
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
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvm_libtool ];

  postInstall = ''
    # Install the swiftmodule.
    mkdir -p "''${!outputDev}/lib/swift/${swiftPlatform}"
    cp -v swift/*.swiftmodule "''${!outputDev}/lib/swift/${swiftPlatform}"

    # Install the ToolsProtocolsCAAtomics module
    mkdir -p "''${!outputDev}/include"
    cp -v ../Sources/ToolsProtocolsCAtomics/include/* "''${!outputDev}/include"

    # Install CMake config file for the SwiftSupportTools library.
    mkdir -p "''${!outputDev}/lib/cmake/SwiftToolsProtocols"
    substitute ${./files/SwiftToolsProtocolsConfig.cmake} "''${!outputDev}/lib/cmake/SwiftToolsProtocols/SwiftToolsProtocolsConfig.cmake" \
      --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
      --replace-fail '@dev@' "''${!outputDev}" \
      --replace-fail '@lib@' "''${!outputLib}" \
      --replace-fail '@swiftPlatform@' ${swiftPlatform}
  '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/swiftlang/swift-tools-protocols";
    description = "Support types used by the Swift toolchain";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
