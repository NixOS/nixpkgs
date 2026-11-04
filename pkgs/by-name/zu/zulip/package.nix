{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_12,
  pnpmConfigHook,
  python3,
  electron_45,
  makeDesktopItem,
  makeBinaryWrapper,
  copyDesktopItems,
}:

let
  electron = electron_45;
  pnpm = pnpm_12;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zulip";
  version = "5.14.2";

  src = fetchFromGitHub {
    owner = "zulip";
    repo = "zulip-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RyYRwD3bx+ZnVhFscf5fK8D0K8TQ+QnbtiZ8CUZiH50=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-7U26LEHueQzNURp8sQuHwzc7zHD0mNXMCxPTeMf0s4Y=";
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
      name = "org.zulip.Zulip";
      exec = "zulip %U";
      icon = "zulip";
      desktopName = "Zulip";
      comment = "Zulip Desktop Client for Linux";
      categories = [
        "Chat"
        "Network"
        "InstantMessaging"
      ];
      startupWMClass = "org.zulip.Zulip";
      terminal = false;
    })
  ];

  meta = {
    description = "Desktop client for Zulip Chat";
    homepage = "https://zulip.com";
    donationPage = "https://zulip.com/help/support-zulip-project";
    downloadPage = "https://github.com/zulip/zulip-desktop";
    changelog = "https://github.com/zulip/zulip-desktop/blob/v${finalAttrs.version}/changelog.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ andersk ];
    platforms = lib.platforms.linux;
    mainProgram = "zulip";
  };
})
