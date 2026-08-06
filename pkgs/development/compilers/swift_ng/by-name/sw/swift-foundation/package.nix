{
  lib,
  cmake,
  fetchFromGitHub,
  ninja,
  stdenv,
  swift-collections,
  swift-foundation-icu,
  swift-minimal,
  swift-syntax,
  swift_release,
  swift_sources,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-foundation";
  version = swift_release;

  outputs = [ "out" ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ "dev" ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-foundation";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.swift-foundation) hash;
  };

  patches = [
    ./patches/0001-gnu-install-dirs.patch
    ./patches/0002-Devendor-SwiftFoundationICU.patch
  ];

  postPatch = ''
    # Build FoundationMacros as a dylib instead of as an executable.
    substituteInPlace Sources/FoundationEssentials/CMakeLists.txt \
      --replace-fail 'set(FoundationMacros_BuildLocalExecutable YES)' 'set(FoundationMacros_BuildLocalExecutable NO)'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Darwin needs to build FoundationMacros as if it’s building the system frameworks, so that they can be used with
    # the system frameworks and SDK.
    substituteInPlace Sources/FoundationMacros/CMakeLists.txt \
      --replace-fail 'target_compile_definitions(FoundationMacros PRIVATE FOUNDATION_MACROS_LIBRARY)' 'target_compile_definitions(FoundationMacros PRIVATE FOUNDATION_FRAMEWORK FOUNDATION_MACROS_LIBRARY)'
  '';

  strictDeps = true;

  preConfigure = ''
    appendToVar cmakeFlags -DCMAKE_Swift_COMPILER_TARGET=${stdenv.hostPlatform.swift.triple}
    appendToVar cmakeFlags -DCMAKE_Swift_FLAGS=-module-cache-path\ "$NIX_BUILD_TOP/module-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    swift-minimal
  ];

  buildInputs = [
    swift-foundation-icu
    swift-syntax
  ];

  cmakeFlags = [
    # Defaults to not building shared libs.
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    # Swift Foundation vendors a private copy of Swift Collections as the `_FoundationCollections` module.
    # We don’t want Swift Collections in the toolchain’s modules folder, so we don’t devendor it.
    (lib.cmakeFeature "_SwiftCollections_SourceDIR" (lib.toString swift-collections.src))
  ];

  # Trying to do a full framework build on Darwin causes the compiler to crash, but fortunately only macros are needed.
  ninjaFlags = lib.optionalString stdenv.hostPlatform.isDarwin "FoundationMacros";

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    install -D lib/libFoundationMacros.dylib -t "$out/lib/swift/host/plugins"
    install_name_tool "$out/lib/swift/host/plugins/libFoundationMacros.dylib" -id "$out/lib/swift/host/plugins/libFoundationMacros"

    runHook postInstall
  '';

  postInstall = (
    lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      moveToOutput lib/swift/host "''${!outputDev}"
      moveToOutput lib/swift/_FoundationCShims "''${!outputDev}"

      rmdir "''${!outputDev}/include"

      # Install CMake config file for the Swift Foundation library.
      mkdir -p "''${!outputDev}/lib/cmake/SwiftFoundation"
      substitute ${./files/SwiftFoundationConfig.cmake} "''${!outputDev}/lib/cmake/SwiftFoundation/SwiftFoundationConfig.cmake" \
        --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
        --replace-fail '@dev@' "''${!outputDev}" \
        --replace-fail '@lib@' "''${!outputLib}" \
        --replace-fail '@swiftPlatform@' ${stdenv.hostPlatform.swift.platform}

      # Copy the _FoundationCollections module. It’s not installed by default.
      moduleDir=''${!outputDev}/lib/swift/${stdenv.hostPlatform.swift.platform}/_FoundationCollections.swiftmodule
      mkdir -p "$moduleDir"
      cp swift/_FoundationCollections.swiftmodule "$moduleDir/${stdenv.hostPlatform.swift.triple}.swiftmodule"
    ''
    + lib.optionalString (stdenv.hostPlatform.isElf && !stdenv.hostPlatform.isStatic) ''
      # Make sure Swift Foundation has an rpath pointing at the stdlib (since it is installed outside of it).
      for so in FoundationEssentials FoundationInternationalization; do
        patchelf --add-rpath ${
          lib.escapeShellArg (
            lib.makeSearchPathOutput "out" "lib/swift/${stdenv.hostPlatform.swift.platform}" [ swift-minimal ]
          )
        } "$out/lib/lib$so${stdenv.hostPlatform.extensions.sharedLibrary}"
      done
    ''
  );

  __structuredAttrs = true;

  meta = {
    description = "Swift implementation of Foundation frameworks";
    homepage = "https://github.com/swiftlang/swift-foundation";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
