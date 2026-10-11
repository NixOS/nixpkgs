{
  lib,
  fetchFromGitHub,
  stdenv,
  swift,
  libicns,
  nix-update-script,
}:

let
  infoPlist =
    version:
    lib.generators.toPlist { escape = true; } {
      CFBundleName = "Tendedero";
      CFBundleDisplayName = "Tendedero";
      CFBundleIdentifier = "app.tendedero.Tendedero";
      CFBundleExecutable = "Tendedero";
      CFBundleIconFile = "Tendedero";
      CFBundlePackageType = "APPL";
      CFBundleShortVersionString = version;
      CFBundleVersion = "1";
      LSMinimumSystemVersion = "14.0";
      LSUIElement = true;
      NSHighResolutionCapable = true;
      NSDesktopFolderUsageDescription = "Tendedero watches the folder where macOS saves your screenshots so it can hang them on the line.";
    };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "tendedero";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "alejandrobujan";
    repo = "tendedero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RZx2cv2Vt/OfKwQBMKmzXGvn6IUeeHDC0HBzoxNXB1U=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  dontConfigure = true;

  nativeBuildInputs = [
    swift
    libicns
  ];

  buildPhase = ''
    runHook preBuild

    swiftFiles=()
    while IFS= read -r -d "" f; do
      swiftFiles+=("$f")
    done < <(find Sources -name '*.swift' -print0)

    buildDir="$PWD/build"
    mkdir -p "$buildDir"

    swiftc \
      -O \
      -swift-version 5 \
      -module-name Tendedero \
      -Xlinker -platform_version -Xlinker macos -Xlinker 14.0 -Xlinker 26.0 \
      -framework AppKit \
      -framework Carbon \
      -framework Cocoa \
      -framework Combine \
      -framework ServiceManagement \
      -framework SwiftUI \
      -framework QuartzCore \
      -framework UniformTypeIdentifiers \
      "''${swiftFiles[@]}" \
      -o "$buildDir/Tendedero"

    # Icon
    iconPng="$buildDir/icon.png"
    swift scripts/make-icon.swift $iconPng
    png2icns $buildDir/Tendedero.icns $iconPng

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    contents=$out/Applications/Tendedero.app/Contents
    mkdir -p $contents/{MacOS,Resources}

    mv $buildDir/Tendedero $contents/MacOS

    printf '%s' ${lib.escapeShellArg (infoPlist finalAttrs.version)} > $contents/Info.plist

    cp -r $buildDir/Tendedero.icns $contents/Resources/Tendedero.icns

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiny native macOS app that hangs every screenshot on a line at the top of your screen";
    homepage = "https://github.com/alejandrobujan/tendedero";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
  };
})
