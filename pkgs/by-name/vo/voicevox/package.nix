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
  pnpm_10,

  _7zz,
  electron,
  voicevox-engine,
}:

let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "voicevox";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "VOICEVOX";
    repo = "voicevox";
    tag = finalAttrs.version;
    hash = "sha256-s8+uHwqxK9my/850C52VT5kshlGrHOOHtopUlsowNeI=";
  };

  patches = [
    (replaceVars ./hardcode-paths.patch {
      electron_path = lib.getExe electron;
      sevenzip_path = lib.getExe _7zz;
      voicevox_engine_path = lib.getExe voicevox-engine;
    })
  ];

  postPatch = ''
    # unlock the overly specific pnpm package version pin
    # and also set version to a proper value
    jq "del(.packageManager) | .version = \"$version\"" package.json | sponge package.json
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

    fetcherVersion = 1;
    hash = "sha256-no0oFhy7flet9QH4FEkPJdlwNq5YkjIx8Uat3M2ruKI=";
  };

  nativeBuildInputs = [
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
    pnpm run electron:build:compile

    pnpm exec electron-builder \
      --dir \
      --config ./build/electronBuilderConfigLoader.cjs \
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
