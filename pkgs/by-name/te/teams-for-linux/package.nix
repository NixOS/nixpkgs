{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  alsa-utils,
  copyDesktopItems,
  electron_32,
  makeDesktopItem,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
  which,
}:

buildNpmPackage rec {
  pname = "teams-for-linux";
  version = "1.12.5";

  src = fetchFromGitHub {
    owner = "IsmaelMartinez";
    repo = "teams-for-linux";
    rev = "refs/tags/v${version}";
    hash = "sha256-w2JcNynsbkk29Lx3XiEGSRzSfrA1NbD0NiTDAYvpl+o=";
  };

  npmDepsHash = "sha256-9GXF3huM4vsQqWmCgkGTx/g3F3oWzDxAZUZNwPWPk1s=";

  nativeBuildInputs = [
    makeWrapper
    versionCheckHook
  ] ++ lib.optionals (stdenv.hostPlatform.isLinux) [ copyDesktopItems ];

  doInstallCheck = stdenv.hostPlatform.isLinux;

  env = {
    # disable code signing on Darwin
    CSC_IDENTITY_AUTO_DISCOVERY = "false";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  buildPhase = ''
    runHook preBuild

    cp -r ${electron_32.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
        --dir \
        -c.npmRebuild=true \
        -c.asarUnpack="**/*.node" \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron_32.version}

    runHook postBuild
  '';

  installPhase =
    ''
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
      makeWrapper '${lib.getExe electron_32}' "$out/bin/teams-for-linux" \
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
      exec = "teams-for-linux";
      icon = "teams-for-linux";
      desktopName = "Microsoft Teams for Linux";
      comment = meta.description;
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  versionCheckProgramArg = [ "--version" ];

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
    ];
    platforms = with lib.platforms; darwin ++ linux;
  };
}
