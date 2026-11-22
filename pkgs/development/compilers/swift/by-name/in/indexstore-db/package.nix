{
  lib,
  cmake,
  fetchFromGitHub,
  fixUnhelpfulCmakeRpathsHook,
  ninja,
  stdenv,
  swift,
  swift-collections,
  swift-corelibs-foundation,
  swift-corelibs-libdispatch,
  swift-foundation,
  swift-foundation-icu,
  swift-lmdb,
  swift_sources,
  swift_release,
}:

let
  swiftPlatform = stdenv.hostPlatform.swift.platform;

  swift' = swift.override {
    enableRepl = false;
    enableSourceKitLSP = false;
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "indexstore-db";
  version = swift_release;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "indexstore-db";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.indexstore-db) hash;
  };

  patches = [ ./patches/0001-gnu-install-dirs.patch ];

  strictDeps = true;

  cmakeFlags = [ (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic)) ];

  preConfigure = ''
    appendToVar cmakeFlags -DCMAKE_Swift_COMPILER_TARGET=${stdenv.hostPlatform.swift.triple}
    appendToVar cmakeFlags -DCMAKE_Swift_FLAGS=-module-cache-path\ "$NIX_BUILD_TOP/module-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    swift'
    fixUnhelpfulCmakeRpathsHook
  ];

  buildInputs = [
    swift-collections
    swift-lmdb
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    swift-corelibs-foundation
    swift-corelibs-libdispatch
    swift-foundation
  ];

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mv "$out/lib/swift/darwin" "$out/lib/swift/${swiftPlatform}"
    ''
    + ''
      moveToOutput lib/swift/${swiftPlatform} "$dev"

      # Install CMake config file for the IndexStoreDB library.
      mkdir -p "''${!outputDev}/lib/cmake/IndexStoreDB"
      substitute ${./files/IndexStoreDBConfig.cmake} "''${!outputDev}/lib/cmake/IndexStoreDB/IndexStoreDBConfig.cmake" \
        --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
        --replace-fail '@dev@' "''${!outputDev}" \
        --replace-fail '@lib@' "''${!outputLib}" \
        --replace-fail '@swiftPlatform@' ${swiftPlatform}
    ''
    + lib.optionalString stdenv.hostPlatform.isElf ''
      patchelf "''${!outputLib}/lib/libIndexStoreDB.so" \
        --add-rpath ${lib.escapeShellArg (lib.makeLibraryPath [ swift-lmdb ])}
    '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/swiftlang/indexstore-db";
    description = "Index database library used by SourceKit-LSP";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
