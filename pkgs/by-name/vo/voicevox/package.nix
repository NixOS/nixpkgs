{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  replaceVars,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  electron,
  _7zz,
  voicevox-engine,
  dart-sass,
}:

buildNpmPackage rec {
  pname = "voicevox";
  version = "0.22.4";

  src = fetchFromGitHub {
    owner = "VOICEVOX";
    repo = "voicevox";
    tag = version;
    hash = "sha256-IOs3wBcFYpO4AHiWFOQWd5hp6EmwyA7Rcc8wjHKvYNQ=";
  };

  patches = [
    (replaceVars ./hardcode-paths.patch {
      sevenzip_path = lib.getExe _7zz;
      voicevox_engine_path = lib.getExe voicevox-engine;
    })
  ];

  postPatch = ''
    substituteInPlace package.json \
        --replace-fail "999.999.999" "${version}" \
        --replace-fail "postinstall" "_postinstall"
  '';

  npmDepsHash = "sha256-NuKFhDb/J6G3pFYHZedKnY2hDC5GCp70DpqrST4bJMA=";

  # unlock very specific node version bounds specified by upstream
  npmInstallFlags = [ "--engine-strict=false" ];

  nativeBuildInputs =
    [
      makeWrapper
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      copyDesktopItems
    ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # disable code signing on Darwin
  env.CSC_IDENTITY_AUTO_DISCOVERY = "false";

  buildPhase = ''
    runHook preBuild

    # force sass-embedded to use our own sass instead of the bundled one
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
        --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'

    # build command taken from the definition of the `electron:build` npm script
    VITE_TARGET=electron npm exec vite build

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
        --dir \
        --config electron-builder.config.js \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 public/icon.png $out/share/icons/hicolor/256x256/apps/voicevox.png

      mkdir -p $out/share/voicevox
      cp -r dist_electron/*-unpacked/{locales,resources{,.pak}} $out/share/voicevox

      makeWrapper ${lib.getExe electron} $out/bin/voicevox \
        --add-flags $out/share/voicevox/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --inherit-argv0
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -r dist_electron/mac*/VOICEVOX.app $out/Applications
      makeWrapper $out/Applications/VOICEVOX.app/Contents/MacOS/VOICEVOX $out/bin/voicevox
    ''}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "voicevox";
      exec = "voicevox";
      icon = "voicevox";
      desktopName = "VOICEVOX";
      categories = [ "AudioVideo" ];
      mimeTypes = [ "application/x-voicevox" ];
    })
  ];

  meta = {
    changelog = "https://github.com/VOICEVOX/voicevox/releases/tag/${src.tag}";
    description = "Editor for the VOICEVOX speech synthesis software";
    homepage = "https://github.com/VOICEVOX/voicevox";
    license = lib.licenses.lgpl3Only;
    mainProgram = "voicevox";
    maintainers = with lib.maintainers; [
      tomasajt
      eljamm
    ];
    platforms = electron.meta.platforms;
  };
}
