{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
  python3,
  electron_42,
  makeDesktopItem,
  makeBinaryWrapper,
  copyDesktopItems,
}:

let
  electron = electron_42;
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zulip";
  version = "5.12.4";

  src = fetchFromGitHub {
    owner = "zulip";
    repo = "zulip-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0TQKQfjfA1Nn/xvtHF0t6i+whLkyu1kVwuZ62Z0AZgk=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-D9Ge0Ao1fnVA1hk+K1ScZ3iCnl1+iqUtZSG5ACO2H2M=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    makeBinaryWrapper
    copyDesktopItems
    python3
  ];

  buildPhase = ''
    runHook preBuild

    pnpm exec electron-vite build
    npm_package_config_node_gyp_nodedir=${electron.headers} \
      pnpm exec electron-builder --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/zulip"
    cp -r dist/*-unpacked/resources/app.asar* "$out/share/lib/zulip/"

    install -m 444 -D app/resources/zulip.png $out/share/icons/hicolor/512x512/apps/zulip.png

    makeBinaryWrapper '${lib.getExe electron}' "$out/bin/zulip" \
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
