{
  lib,
  stdenv,
  electron,
  fetchFromGitHub,
  fetchurl,
  fetchYarnDeps,
  fixup-yarn-lock,
  replaceVars,
  writableTmpDirAsHomeHook,
  makeWrapper,
  nodejs,
  yarn,
  libglvnd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "unofficial-homestuck-collection";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "GiovanH";
    repo = "unofficial-homestuck-collection";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0RPZfXdcdBo1OxJU3eSRF7fEO5EYMyJCcAZLEqzDMRk=";
  };

  patches = [
    (replaceVars ./0001-disable-git-rev-check.patch {
      git_branch = "'main'";
      git_revision = "'${finalAttrs.src.rev}'";
      git_remote = "'${finalAttrs.src.url}'";
    })
    ./0002-disable-update-check.patch
    ./0003-make-compatible-with-native-electron.patch
  ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-mo5Ir/pLoqc6K/0AOJqKC0yup7vx9UrNfQ+casIgBCo=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    makeWrapper
    nodejs
    writableTmpDirAsHomeHook
    yarn
  ];

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
    echo > node_modules/electron/index.js

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    make src/imods.tar.gz
    make src/js/crc_imods.json
    env NODE_OPTIONS=--max_old_space_size=8192 \
      yarn run vue-cli-service electron:build \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version} \
      --config ${./electron-builder.yml}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for i in 16x16 24x24 48x48 64x64 128x128 256x256 512x512; do
      install -Dm644 build/icons/$i.png $out/share/icons/hicolor/$i/apps/dev.bambosh.UnofficialHomestuckCollection.png
    done
    install -Dm644 build/dev.bambosh.UnofficialHomestuckCollection.metainfo.xml $out/share/metainfo/dev.bambosh.UnofficialHomestuckCollection.metainfo.xml
    install -Dm644 build/dev.bambosh.UnofficialHomestuckCollection.desktop $out/share/applications/dev.bambosh.UnofficialHomestuckCollection.desktop
    install  -d $out/bin $out/share/unofficial-homestuck-collection
    cp -r dist_electron/*-unpacked/{locales,resources{,.pak}} $out/share/unofficial-homestuck-collection
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

  meta = {
    description = "Offline collection of Homestuck and its related works (ruffle only)";
    homepage = "https://homestuck.giovanh.com/unofficial-homestuck-collection/";
    changelog = "https://github.com/GiovanH/unofficial-homestuck-collection/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      kenshineto
    ];
    mainProgram = "unofficial-homestuck-collection";
    platforms = lib.platforms.linux;
  };
})
