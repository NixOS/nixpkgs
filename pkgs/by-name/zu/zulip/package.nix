{
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

  src = fetchFromGitHub {
    owner = "zulip";
    repo = "zulip-desktop";
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

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/zulip"
    cp -r dist/*-unpacked/resources/app.asar* "$out/share/lib/zulip/"

    install -m 444 -D app/resources/zulip.png $out/share/icons/hicolor/512x512/apps/zulip.png

    makeShellWrapper '${lib.getExe electron_37}' "$out/bin/zulip" \
      --add-flags "$out/share/lib/zulip/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-wayland-ime=true}}" \
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

  meta = with lib; {
    description = "Desktop client for Zulip Chat";
    homepage = "https://zulip.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
    platforms = lib.platforms.linux;
    mainProgram = "zulip";
  };
}
