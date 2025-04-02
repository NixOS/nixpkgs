{
  lib,
  stdenv,
  electron,
  fetchFromGitHub,
  fetchurl,
  fetchYarnDeps,
  fixup-yarn-lock,
  writableTmpDirAsHomeHook,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  nodejs,
  yarn,
  libglvnd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "unofficial-homestuck-collection";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "GiovanH";
    repo = "unofficial-homestuck-collection";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hmGvOsx5OUesXD3Nat00IVDra36IpeFLFklwcMu1UTU=";
  };

  patches = [
    ./0001-fix-source.patch
  ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-mo5Ir/pLoqc6K/0AOJqKC0yup7vx9UrNfQ+casIgBCo=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    fixup-yarn-lock
    makeWrapper
    nodejs
    writableTmpDirAsHomeHook
    yarn
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  configurePhase = ''
    runHook preConfigure

    # setup yarn
    fixup-yarn-lock yarn.lock
    yarn config --offline set ignore-engines true
    yarn config --offline set yarn-offline-mirror $offlineCache
    yarn install --offline --frozen-lockfile --ignore-scripts --no-progress
    patchShebangs node_modules

    # fixup node_modules
    echo > node_modules/phantomjs-prebuilt/install.js
    touch node_modules/electron/path.txt

    # update git rev
    substituteInPlace vue.config.js \
      --replace-fail NIX_GIT_REVISION "'v${finalAttrs.version}'";

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    pushd node_modules/phantomjs-prebuilt
    node install.js
    popd

    make src/imods.tar.gz
    make src/js/crc_imods.json
    env NODE_OPTIONS=--max_old_space_size=8192 \
      yarn run vue-cli-service electron:build \
      --linux --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version} \
      --config ${./electron-builder.yml}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/icons/16x16.png $out/share/icons/hicolor/16x16/apps/unofficial-homestuck-collection.png
    install -Dm644 build/icons/24x24.png $out/share/icons/hicolor/24x24/apps/unofficial-homestuck-collection.png
    install -Dm644 build/icons/32x32.png $out/share/icons/hicolor/32x32/apps/unofficial-homestuck-collection.png
    install -Dm644 build/icons/48x48.png $out/share/icons/hicolor/48x48/apps/unofficial-homestuck-collection.png
    install -Dm644 build/icons/64x64.png $out/share/icons/hicolor/64x64/apps/unofficial-homestuck-collection.png
    install -Dm644 build/icons/128x128.png $out/share/icons/hicolor/128x128/apps/unofficial-homestuck-collection.png
    install -Dm644 build/icons/256x256.png $out/share/icons/hicolor/256x256/apps/unofficial-homestuck-collection.png
    install -Dm644 build/icons/512x512.png $out/share/icons/hicolor/512x512/apps/unofficial-homestuck-collection.png
    install -Dm644 build/icons/1024x1024.png $out/share/icons/hicolor/1024x1024/apps/unofficial-homestuck-collection.png

    mkdir -p $out/share/unofficial-homestuck-collection $out/bin
    cp -r dist_electron/linux-unpacked/{locales,resources{,.pak}} $out/share/unofficial-homestuck-collection
    makeWrapper ${lib.getExe electron} $out/bin/unofficial-homestuck-collection \
      --add-flags $out/share/unofficial-homestuck-collection/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --add-flags --no-sandbox \
      --set LD_LIBRARY_PATH "${
        lib.makeLibraryPath [
          libglvnd
        ]
      }" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "unofficial-homestuck-collection";
      exec = "unofficial-homestuck-collection";
      icon = "unofficial-homestuck-collection";
      desktopName = "unofficial-homestuck-collection";
      categories = [ "Game" ];
      mimeTypes = [ "x-scheme-handler/mspa" ];
    })
  ];

  meta = {
    description = "Offline collection of Homestuck and its related works";
    homepage = "https://homestuck.giovanh.com/unofficial-homestuck-collection/";
    changelog = "https://github.com/GiovanH/unofficial-homestuck-collection/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      kenshineto
    ];
    mainProgram = "unofficial-homestuck-collection";
    # TODO: kenshineto: macos support, i dont own a mac
    platforms = lib.platforms.linux;
  };
})
