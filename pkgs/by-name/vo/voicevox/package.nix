{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  replaceVars,

  copyDesktopItems,
  dart-sass,
  jq,
  makeWrapper,
  moreutils,
  nodejs,
  pnpm_9,

  _7zz,
  electron,
  voicevox-engine,
}:

let
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "voicevox";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "VOICEVOX";
    repo = "voicevox";
    tag = finalAttrs.version;
    hash = "sha256-2MXJOLt14zpoahYjd3l3q5UxT2yK/g/jksHO4Q7W6HA=";
  };

  patches = [
    (replaceVars ./hardcode-paths.patch {
      sevenzip_path = lib.getExe _7zz;
      voicevox_engine_path = lib.getExe voicevox-engine;
    })
  ];

  postPatch = ''
    # unlock the overly specific pnpm package version pin
    jq 'del(.packageManager)' package.json | sponge package.json

    substituteInPlace package.json \
      --replace-fail "999.999.999" "$version" \
      --replace-fail ' && electron-builder --config electron-builder.config.cjs --publish never' ""
  '';

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      postPatch
      ;

    # let's just be safe and add these explicitly to nativeBuildInputs
    # even though the fetcher already uses them in its implementation
    nativeBuildInputs = [
      jq
      moreutils
    ];

    hash = "sha256-RKgqFmHQnjHS7yeUIbH9awpNozDOCCHplc/bmfxmMyg=";
  };

  nativeBuildInputs =
    [
      dart-sass
      jq
      makeWrapper
      moreutils
      nodejs
      pnpm.configHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      copyDesktopItems
    ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # disable code signing on Darwin
  env.CSC_IDENTITY_AUTO_DISCOVERY = "false";

  buildPhase = ''
    runHook preBuild

    # force sass-embedded to use our own sass from PATH instead of the bundled one
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["dart-sass"];'

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    # note: we patched out the call to electron-builder in postPatch
    pnpm run electron:build

    pnpm exec electron-builder \
      --dir \
      --config electron-builder.config.cjs \
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
