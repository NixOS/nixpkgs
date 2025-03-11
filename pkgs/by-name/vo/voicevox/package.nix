{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  pnpm_9,
  nodejs,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  electron,
  _7zz,
  voicevox-engine,
  dart-sass,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "voicevox";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "VOICEVOX";
    repo = "voicevox";
    tag = finalAttrs.version;
    hash = "sha256-wCC4wl5LPJVJQtV+X795rIXnURseQYiCZ9B6YujTFFw=";
  };

  patches = [
    ./unlock-node-and-pnpm-versions.patch
    (replaceVars ./hardcode-paths.patch {
      sevenzip_path = lib.getExe _7zz;
      voicevox_engine_path = lib.getExe voicevox-engine;
    })
  ];

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "999.999.999" "$version" \
      --replace-fail ' && electron-builder --config electron-builder.config.js --publish never' ""
  '';

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    hash = "sha256-IuyDHAomaGEvGbN4gLpyPfZGm/pF9XK+BkXSipaM7NQ=";
  };

  nativeBuildInputs =
    [
      makeWrapper
      pnpm_9.configHook
      nodejs
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

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    # note: we patched out the call to electron-builder in postPatch
    pnpm run electron:build

    pnpm exec electron-builder \
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
    changelog = "https://github.com/VOICEVOX/voicevox/releases/tag/${finalAttrs.src.tag}";
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
})
