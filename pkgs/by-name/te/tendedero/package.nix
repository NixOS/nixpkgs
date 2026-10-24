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
      CFBundleDevelopmentRegion = "en";
      CFBundleLocalizations = [ ];
      LSMinimumSystemVersion = "14.0";
      LSUIElement = true;
      NSHighResolutionCapable = true;
      NSDesktopFolderUsageDescription = "Tendedero watches the folder where macOS saves your screenshots so it can hang them on the line.";
      NSDocumentsFolderUsageDescription = "Tendedero watches the folder you chose so it can hang new images on the line.";
      NSDownloadsFolderUsageDescription = "Tendedero watches the folder you chose so it can hang new images on the line.";
    };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "tendedero";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "alejandrobujan";
    repo = "tendedero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b+9oKoNCJiSGy09zqvI0V+uxZjlVxUwXok74MISncFY=";
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

    mkdir $buildDir/Resources

    # Icon
    iconPng="$buildDir/icon.png"
    swift scripts/make-icon.swift $iconPng
    png2icns $buildDir/Resources/Tendedero.icns $iconPng

    # Info.plist
    printf '%s' ${lib.escapeShellArg (infoPlist finalAttrs.version)} > $buildDir/Info.plist
    LANGUAGES=""
    for dir in Sources/Tendedero/Resources/*.lproj; do
      cp -R "$dir" "$buildDir/Resources/"
      LANGUAGES="$LANGUAGES<string>$(basename "$dir" .lproj)</string>"
    done
    substituteInPlace $buildDir/Info.plist \
      --replace-fail $'<key>CFBundleLocalizations</key>\n\t<array>\n\n\t</array>' \
                     $'<key>CFBundleLocalizations</key>\n\t<array>'"''${LANGUAGES}"$'</array>'

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    contents=$out/Applications/Tendedero.app/Contents
    mkdir -p $contents/MacOS

    mv $buildDir/Info.plist $contents
    mv $buildDir/Resources $contents
    mv $buildDir/Tendedero $contents/MacOS

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiny native macOS app that hangs every screenshot on a line at the top of your screen";
    homepage = "https://tendedero.app";
    changelog = "https://github.com/alejandrobujan/tendedero/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
  };
})
