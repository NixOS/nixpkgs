{
  lib,
  stdenv,
  swift,
  swiftpm,
}:

stdenv.mkDerivation {
  name = "test-swiftpm-swift-testing";
  src = ./src;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  postPatch = ''
    substituteInPlace Package.swift \
      --replace-fail '@darwinMinVersion@' '${stdenv.hostPlatform.darwinMinVersion}'
  '';

  buildPhase = ''
    runHook preBuild

    flagsArray=()
    concatTo flagsArray swiftpmFlags swiftpmFlagsArray
    testFlags=(
      --disable-sandbox --disable-xctest
      -j "$NIX_BUILD_CORES"
      -Xswiftc -module-cache-path -Xswiftc "$NIX_BUILD_TOP/module-cache"
      "''${flagsArray[@]}"
    )

    # No custom toolset: SwiftPM must locate its installed helper itself.
    swift test "''${testFlags[@]}" > success.log 2>&1 || { cat success.log; exit 1; }
    grep -F 'Test run with 1 test' success.log

    # Verify that the helper also propagates a failing test's exit status.
    substituteInPlace Tests/SmokeTests.swift --replace-fail '2 + 2 == 4' '2 + 2 == 5'
    if swift test "''${testFlags[@]}" > failure.log 2>&1; then
      cat failure.log
      echo "Swift Testing unexpectedly accepted a failing test" >&2
      exit 1
    fi
    grep -F 'Expectation failed' failure.log

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp success.log failure.log "$out/"
    runHook postInstall
  '';

  meta.platforms = lib.platforms.darwin;
}
