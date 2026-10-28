{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  copyDesktopItems,
  electron,
  fixup-yarn-lock,
  imagemagick,
  makeDesktopItem,
  node-gyp-build,
  nodejs,
  writableTmpDirAsHomeHook,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sylk";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "sylk-webrtc";
    tag = finalAttrs.version;
    hash = "sha256-AJbZDAEqGfVPuo+My8wxfFWVPelO6XK2pKsglmLyRTw=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-VY97NPnT1225l6SLyTI3qITBGF7rqE5xz6UVVucblcU=";
  };

  # required for electron
  passthru.appOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/app/yarn.lock";
    hash = "sha256-S9L/rveTuXF2vSqSDu+NlV5vP5f28lda/KMGU8iS1Zo=";
  };

  outputs = [
    "out"
    "deps"
    "electronDeps"
  ];

  nativeBuildInputs = [
    copyDesktopItems
    fixup-yarn-lock
    imagemagick
    node-gyp-build
    nodejs # needed for executing package.json scripts
    writableTmpDirAsHomeHook
    yarnBuildHook
    yarnConfigHook
    yarnInstallHook
  ];

  dontConfigure = true;
  yarnBuildScript = "electron";

  preBuild = ''
    originalOfflineMirror=$(yarn config --offline get yarn-offline-mirror)

    installDeps() {
      local cache="$1"
      local output="$2"
      fixup-yarn-lock yarn.lock
      yarn config --offline set yarn-offline-mirror "$cache"
      yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts
      patchShebangs node_modules/
      mkdir -p $output
      cp -R node_modules $output
    }

    installDeps $yarnOfflineCache $deps

    pushd app
    installDeps ${finalAttrs.passthru.appOfflineCache} $electronDeps
    popd

    yarn config --offline set yarn-offline-mirror $originalOfflineMirror
  '';

  postFixup = ''
    mkdir -p $out/share
    mv $out/lib/node_modules/Sylk $out/share/Sylk

    rm -rf $out/lib
    rm -rf $out/share/Sylk/.parcel-cache
    rm -rf $out/share/Sylk/node_modules

    ln -s $electronDeps/node_modules $out/share/Sylk/app/node_modules
    ln -s $deps/node_modules $out/share/Sylk/node_modules

    makeWrapper ${lib.getExe electron} $out/bin/sylk \
      --add-flags $out/share/Sylk/app \
      --inherit-argv0

    # Convert the .ico file to PNGs, which are used by the desktop file
    for size in 16 24 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick "$out/share/Sylk/build/icon.ico" -delete 1--1 \
        -background none \
        -thumbnail "$size"x"$size" \
        $out/share/icons/hicolor/"$size"x"$size"/apps/sylk-electron.png
    done;
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "sylk";
      exec = "sylk";
      desktopName = "Sylk";
      comment = "WebRTC client";
      icon = "sylk-electron";
      startupWMClass = "Sylk";
      terminal = false;
      categories = [
        "Audio"
        "Video"
        "AudioVideo"
      ];
    })
  ];

  meta = {
    description = "Desktop client for SylkServer, a multiparty conferencing tool";
    homepage = "https://sylkserver.com/";
    license = lib.licenses.agpl3Plus;
    changelog = "https://github.com/AGProjects/sylk-webrtc/blob/${finalAttrs.src.rev}/changelog.txt";
    mainProgram = "sylk";
    maintainers = with lib.maintainers; [ zimbatm ];
    teams = with lib.teams; [ ngi ];
    platforms = electron.meta.platforms;
  };
})
