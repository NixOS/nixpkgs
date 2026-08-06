{
  lib,
  cmake,
  fetchFromGitHub,
  ninja,
  swift-minimal,
  stdenv,
  swift-foundation,
  swift-foundation-icu,
  swift-corelibs-libdispatch,
  libxml2,
  curl,
  swift_release,
  swift_sources,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-corelibs-foundation";
  version = swift_release;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-corelibs-foundation";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.swift-corelibs-foundation) hash;
  };

  patches = [
    ./patches/0001-gnu-install-dirs.patch
    ./patches/0002-Devendor-SwiftFoundation-and-SwiftFoundationICU.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    swift-minimal
  ];

  buildInputs = [
    curl
    libxml2
    swift-corelibs-libdispatch
    swift-foundation
    swift-foundation-icu
  ];

  postInstall = ''
    moveToOutput lib/swift "''${!outputDev}"

    # Install CMake config file for the Swift Collections library.
    mkdir -p "''${!outputDev}/lib/cmake/Foundation"
    substitute ${./files/FoundationConfig.cmake} "''${!outputDev}/lib/cmake/Foundation/FoundationConfig.cmake" \
      --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
      --replace-fail '@dev@' "''${!outputDev}" \
      --replace-fail '@lib@' "''${!outputLib}" \
      --replace-fail '@swiftPlatform@' ${stdenv.hostPlatform.swift.platform}
  ''
  + lib.optionalString (stdenv.hostPlatform.isElf && !stdenv.hostPlatform.isStatic) ''
    # Make sure swift-corelibs-foundation has an rpath pointing at the stdlib (since it is installed outside of it).
    patchelf --add-rpath ${
      lib.escapeShellArg (
        lib.makeSearchPathOutput "out" "lib/swift/${stdenv.hostPlatform.swift.platform}" [ swift-minimal ]
      )
    } "$out/lib/libFoundation${stdenv.hostPlatform.extensions.sharedLibrary}"
    patchelf --add-rpath ${
      lib.escapeShellArg (lib.makeLibraryPath [ curl ])
    } "$out/lib/libFoundationNetworking${stdenv.hostPlatform.extensions.sharedLibrary}"
    patchelf --add-rpath ${
      lib.escapeShellArg (lib.makeLibraryPath [ libxml2 ])
    } "$out/lib/libFoundationXML${stdenv.hostPlatform.extensions.sharedLibrary}"
  '';

  __structuredAttrs = true;

  meta = {
    description = "Core utilities, internationalization, and OS independence for Swift";
    mainProgram = "plutil";
    homepage = "https://github.com/swiftlang/swift-corelibs-foundation";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
