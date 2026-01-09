{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  python3,
  electron_39,
  makeDesktopItem,
  makeBinaryWrapper,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zulip";
  version = "5.12.3";

  src = fetchFromGitHub {
    owner = "zulip";
    repo = "zulip-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jRco2eyQrWf5jGvdWYn4mt8FD/xu1+FftQoB3wuF2Lw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-s/KllzT46L2o4SWS3z3Z7FDQD6FEEEAnPdM6tsfGRUo=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
    makeBinaryWrapper
    copyDesktopItems
    python3
  ];

  buildPhase = ''
    runHook preBuild

    npm_config_nodedir=${electron_39.headers} \
      node --run pack -- \
      -c.electronDist=${electron_39}/libexec/electron \
      -c.electronVersion=${electron_39.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/zulip"
    cp -r dist/*-unpacked/resources/app.asar* "$out/share/lib/zulip/"

    install -m 444 -D app/resources/zulip.png $out/share/icons/hicolor/512x512/apps/zulip.png

    makeBinaryWrapper '${lib.getExe electron_39}' "$out/bin/zulip" \
      --add-flags "$out/share/lib/zulip/app.asar" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "zulip";
      exec = "zulip %U";
      icon = "zulip";
      desktopName = "Zulip";
      comment = "Zulip Desktop Client for Linux";
      categories = [
        "Chat"
        "Network"
        "InstantMessaging"
      ];
      startupWMClass = "Zulip";
      terminal = false;
    })
  ];

  meta = {
    description = "Desktop client for Zulip Chat";
    homepage = "https://zulip.com";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ andersk ];
    platforms = lib.platforms.linux;
    mainProgram = "zulip";
  };
})
