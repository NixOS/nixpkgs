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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sylk";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "sylk-webrtc";
    tag = finalAttrs.version;
    hash = "sha256-GWvjWUEiGfDh3j5JjRCNCu34aRcl5+hmtqOsw2A1NyI=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-I8MfDCgdh88EqTD5JA9k0bMqMzdq7O/sbff+1W9EsJ8=";
  };

  # required for electron
  passthru.appOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/app/yarn.lock";
    hash = "sha256-8ZdQTsLBuEIaJxEGH58aTROpRd9NCNGUyhcG+HJVz1Q=";
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

  postPatch = ''
    # Skip building the macOS CoreLocation helper binary (requires xcrun swiftc from Xcode CLI tools).
    # So Blink cannot query device geolocation on macOS.
    substituteInPlace build/build-location-helper.js \
      --replace-fail "process.platform !== 'darwin'" "true"
  '';

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
    mv $out/lib/node_modules/Blink $out/share/Blink

    rm -rf $out/lib
    rm -rf $out/share/Blink/.parcel-cache
    rm -rf $out/share/Blink/node_modules

    ln -s $electronDeps/node_modules $out/share/Blink/app/node_modules
    ln -s $deps/node_modules $out/share/Blink/node_modules

    makeWrapper ${lib.getExe electron} $out/bin/blink \
      --add-flags $out/share/Blink/app \
      --inherit-argv0

    # Convert the .ico file to PNGs, which are used by the desktop file
    for size in 16 24 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick "$out/share/Blink/build/icon.ico" -delete 1--1 \
        -background none \
        -thumbnail "$size"x"$size" \
        $out/share/icons/hicolor/"$size"x"$size"/apps/blink-electron.png
    done;

    # keep old alias
    ln -s $out/bin/blink $out/bin/sylk
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "blink";
      exec = "blink";
      desktopName = "Blink";
      comment = "WebRTC client";
      icon = "blink-electron";
      startupWMClass = "Blink";
      terminal = false;
      categories = [
        "Audio"
        "Video"
        "AudioVideo"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--subpackage=appOfflineCache" ]; };

  meta = {
    description = "Desktop client for SylkServer, a multiparty conferencing tool";
    homepage = "https://sylkserver.com/";
    license = lib.licenses.agpl3Plus;
    changelog = "https://github.com/AGProjects/sylk-webrtc/blob/${finalAttrs.src.rev}/changelog.txt";
    mainProgram = "blink";
    maintainers = with lib.maintainers; [ zimbatm ];
    teams = with lib.teams; [ ngi ];
    platforms = electron.meta.platforms;
  };
})
