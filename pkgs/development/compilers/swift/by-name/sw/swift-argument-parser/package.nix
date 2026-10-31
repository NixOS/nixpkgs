{
  lib,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  llvm_libtool,
  ninja,
  stdenv,
  swift-foundation,
  swift-minimal,
}:

let
  swiftPlatform = stdenv.hostPlatform.swift.platform;
  swift = swift-minimal.override { inherit swift-foundation; }; # Swift Argument Parser requires Foundation.
in

# Swift Argument Parser is a dependency to both Swift Compiler Driver and SwiftPM.
# It must be built with CMake and use Swift without swift-driver to avoid dependency cycles.
stdenv.mkDerivation (finalAttrs: {
  pname = "swift-argument-parser";
  version = "1.8.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "apple";
    repo = "swift-argument-parser";
    tag = finalAttrs.version;
    hash = "sha256-BWm2ZbNIvlamNp8cxoicFlAcujjhH22VPzs67lEIXWU=";
  };

  patches = [
    # Install libSwiftArgumentParserToolInfo.a and its module as well.
    ./patches/0001-install-argument-parser-tool-info.patch
  ];

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
    moveToOutput lib/swift "''${!outputDev}"
    moveToOutput lib/swift_static "''${!outputDev}"

    # Install CMake config file for the Swift Argument Parser library.
    mkdir -p "''${!outputDev}/lib/cmake/ArgumentParser"
    substitute ${./files/ArgumentParserConfig.cmake} "''${!outputDev}/lib/cmake/ArgumentParser/ArgumentParserConfig.cmake" \
      --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
      --replace-fail '@include@' "''${!outputDev}" \
      --replace-fail '@lib@' "''${!outputLib}" \
      --replace-fail '@swiftPlatform@' ${swiftPlatform}
  '';

  passthru.updateScript = gitUpdater { };

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/apple/swift-argument-parser";
    description = "Type-safe argument parsing for Swift";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
