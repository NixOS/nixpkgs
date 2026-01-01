{
<<<<<<< HEAD
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
=======
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  python3,
  electron_37,
  makeDesktopItem,
  makeShellWrapper,
  copyDesktopItems,
}:

buildNpmPackage rec {
  pname = "zulip";
  version = "5.12.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "zulip";
    repo = "zulip-desktop";
<<<<<<< HEAD
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
=======
    tag = "v${version}";
    hash = "sha256-+OS3Fw4Z1ZOzXou1sK39AUFLI78nUl4UBVYA3SNH7I0=";
  };

  npmDepsHash = "sha256-5qjBZfl9kse97y5Mru4RF4RLTbojoXeUp84I/bOHEcw=";
  makeCacheWritable = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  nativeBuildInputs = [
    makeShellWrapper
    copyDesktopItems
    (python3.withPackages (ps: with ps; [ distutils ]))
  ];

  dontNpmBuild = true;
  buildPhase = ''
    runHook preBuild

    npm run pack -- \
      -c.electronDist=${electron_37}/libexec/electron \
      -c.electronVersion=${electron_37.version}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/zulip"
    cp -r dist/*-unpacked/resources/app.asar* "$out/share/lib/zulip/"

    install -m 444 -D app/resources/zulip.png $out/share/icons/hicolor/512x512/apps/zulip.png

<<<<<<< HEAD
    makeBinaryWrapper '${lib.getExe electron_39}' "$out/bin/zulip" \
      --add-flags "$out/share/lib/zulip/app.asar" \
=======
    makeShellWrapper '${lib.getExe electron_37}' "$out/bin/zulip" \
      --add-flags "$out/share/lib/zulip/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-wayland-ime=true}}" \
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Desktop client for Zulip Chat";
    homepage = "https://zulip.com";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ andersk ];
    platforms = lib.platforms.linux;
    mainProgram = "zulip";
  };
})
=======
  meta = with lib; {
    description = "Desktop client for Zulip Chat";
    homepage = "https://zulip.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
    platforms = lib.platforms.linux;
    mainProgram = "zulip";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
