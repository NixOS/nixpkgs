{
  lib,
  cmake,
  fetchFromGitHub,
  fixDarwinDylibNames,
  ninja,
  stdenv,
  swift_sources,
  swift_release,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-lmdb";
  version = swift_release;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-lmdb";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.swift-lmdb) hash;
  };

  strictDeps = true;

  cmakeFlags = [ (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic)) ];

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  installPhase =
    # swift-lmdb does not provide an install target, so do it manually.
    ''
      runHook preInstall

      # Install the dylib
      install -m755 -D -t "''${!outputLib}/lib" \
        lib/libCLMDB${stdenv.hostPlatform.extensions.library}

      # Install the headers.
      install -m644 -D -t "''${!outputDev}/include" \
        ../Sources/CLMDB/include/*

      # Install CMake config file for the Swift-LMDB library.
      mkdir -p "''${!outputDev}/lib/cmake/LMDB"
      substitute ${./files/LMDBConfig.cmake} "''${!outputDev}/lib/cmake/LMDB/LMDBConfig.cmake" \
        --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
        --replace-fail '@dev@' "''${!outputDev}" \
        --replace-fail '@lib@' "''${!outputLib}"

      runHook postInstall
    '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/swiftlang/swift-lmdb";
    description = "SwiftPM wrapper around LMDB";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.openldap;
    teams = [ lib.teams.swift ];
  };
})
