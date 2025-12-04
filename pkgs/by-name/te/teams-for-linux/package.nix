{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  alsa-utils,
  copyDesktopItems,
  electron_37,
  makeDesktopItem,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
  vulkan-loader,
  which,
}:

buildNpmPackage rec {
  pname = "teams-for-linux";
  version = "2.6.18";

  src = fetchFromGitHub {
    owner = "IsmaelMartinez";
    repo = "teams-for-linux";
    tag = "v${version}";
    hash = "sha256-hIFr+lJrM3FaCKQhUBzD8kzKaF1ZouCp+QLa558b35s=";
  };

  npmDepsHash = "sha256-brru6gsHwu2wS1Qe2AjjMW9QOVYd2HBUzUvSl1EJ87M=";

  nativeBuildInputs = [
    makeWrapper
    versionCheckHook
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [ copyDesktopItems ];

  doInstallCheck = stdenv.hostPlatform.isLinux;

  env = {
    # disable code signing on Darwin
    CSC_IDENTITY_AUTO_DISCOVERY = "false";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  makeCacheWritable = true;

  buildPhase = ''
    runHook preBuild

    cp -r ${electron_37.dist} electron-dist
    chmod -R u+w electron-dist
  ''
  # Electron builder complains about symlink in electron-dist
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    rm electron-dist/libvulkan.so.1
    cp ${lib.getLib vulkan-loader}/lib/libvulkan.so.1 electron-dist
  ''
  + ''

    npm exec electron-builder -- \
        --dir \
        -c.npmRebuild=true \
        -c.asarUnpack="**/*.node" \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron_37.version} \
        -c.mac.identity=null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/{applications,teams-for-linux}
    cp dist/*-unpacked/resources/app.asar $out/share/teams-for-linux/

    pushd build/icons
    for image in *png; do
      mkdir -p $out/share/icons/hicolor/''${image%.png}/apps
      cp -r $image $out/share/icons/hicolor/''${image%.png}/apps/teams-for-linux.png
    done
    popd

    # Linux needs 'aplay' for notification sounds
    makeWrapper '${lib.getExe electron_37}' "$out/bin/teams-for-linux" \
      --prefix PATH : ${
        lib.makeBinPath [
          alsa-utils
          which
        ]
      } \
      --add-flags "$out/share/teams-for-linux/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r dist/mac*/teams-for-linux.app $out/Applications
    makeWrapper $out/Applications/teams-for-linux.app/Contents/MacOS/teams-for-linux $out/bin/teams-for-linux
  ''
  + ''

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "teams-for-linux";
      exec = "teams-for-linux %U";
      icon = "teams-for-linux";
      desktopName = "Microsoft Teams for Linux";
      comment = meta.description;
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      mimeTypes = [ "x-scheme-handler/msteams" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unofficial Microsoft Teams client for Linux";
    mainProgram = "teams-for-linux";
    homepage = "https://github.com/IsmaelMartinez/teams-for-linux";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      muscaln
      qjoly
      chvp
      khaneliman
      HarisDotParis
    ];
    platforms = with lib.platforms; darwin ++ linux;
  };
}
