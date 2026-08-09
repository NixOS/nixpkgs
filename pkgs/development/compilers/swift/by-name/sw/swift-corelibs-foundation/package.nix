{
  lib,
  cmake,
  curl,
  fetchFromGitHub,
  libxml2,
  ninja,
  stdenv,
  swift-corelibs-libdispatch,
  swift-foundation,
  swift-foundation-icu,
  swift-minimal,
  swift_release,
  swift_sources,
}:

let
  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in

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
    # Make sure swift-corelibs-foundation has an rpath pointing at the stdlib (since it is installed outside of it)
    # as well as to Dispatch and Swift Foundation. Also do the same for `plutil`.
    for f in "$out/bin/plutil" "$out/lib/libFoundation${stdenv.hostPlatform.extensions.sharedLibrary}"; do
      patchelf --add-rpath ${
        lib.escapeShellArg (
          lib.makeSearchPathOutput "out" "lib/swift/${stdenv.hostPlatform.swift.platform}" [ swift-minimal ]
        )
      } "$f"
      patchelf --add-rpath ${
        lib.escapeShellArg (
          lib.makeLibraryPath [
            # Need both for the Swift and non-Swift shared libraries
            swift-corelibs-libdispatch
            (swift-corelibs-libdispatch.override { useSwift = false; })
            swift-foundation
          ]
        )
      } "$f"
    done
    patchelf --add-rpath ${
      lib.escapeShellArg (lib.makeLibraryPath [ curl ])
    } "$out/lib/libFoundationNetworking${stdenv.hostPlatform.extensions.sharedLibrary}"
    patchelf --add-rpath ${
      lib.escapeShellArg (lib.makeLibraryPath [ libxml2 ])
    } "$out/lib/libFoundationXML${stdenv.hostPlatform.extensions.sharedLibrary}"
  '';

  inherit doInstallCheck;

  # Can’t use `versionCheckHook` because `plutil` does not have an option to print the version.
  installCheckPhase = ''
    runHook preInstallCheck

    "''${!outputBin}/bin/${finalAttrs.meta.mainProgram}" -help | grep "plutil:"

    runHook postInstallCheck
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
