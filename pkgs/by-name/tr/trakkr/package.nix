{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  makeDesktopItem,
  copyDesktopItems,
  nodejs_20,
  electron_33,
}:
buildNpmPackage rec {
  pname = "trakkr";
  version = "0.1.7";
  nodejs = nodejs_20;

  src = fetchFromGitHub {
    owner = "skybreakdigital";
    repo = "${pname}-app";
    tag = "v${version}";
    hash = "sha256-roL0PVytPPpmkz/6yCvrtaTUhNvqvEh0/uRyPWiJj7I=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  npmDepsHash = "sha256-qKnyFw2wnSTywKQIFADEAF/D8HsENICjqbSI4yWsZAU=";

  buildPhase = ''
    runHook preBuild

    npm exec vite -- build

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron_33.dist} \
      -c.electronVersion=${electron_33.version} \
      --publish=never

    runHook postBuild
  '';

  nativeBuildInputs = [ copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    install -Dm644 ${src}/public/icon.png $out/share/icons/hicolor/256x256/apps/Trakkr.png
    install -Dm644 ${src}/public/favicon-16x16.png $out/share/icons/hicolor/16x16/apps/Trakkr.png
    install -Dm644 ${src}/public/favicon-32x32.png $out/share/icons/hicolor/32x32/apps/Trakkr.png

    mkdir -p "$out/share/lib/Trakkr"
    cp -r ./dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/Trakkr"
    cp ./dist/index.html "$out/share/lib/Trakkr"


    # Code relies on checking app.isPackaged, which returns false if the executable is electron.
    # Set ELECTRON_FORCE_IS_PACKAGED=1.
    # https://github.com/electron/electron/issues/35153#issuecomment-1202718531
    makeWrapper '${electron_33}/bin/electron' "$out/bin/Trakkr" \
      --add-flags "$out/share/lib/Trakkr/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags "--disable-gpu" \
      --add-flags "--disable-gpu-rendering" \
      --set ELECTRON_FORCE_IS_PACKAGED=1 \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Trakkr";
      exec = "Trakkr";
      icon = "Trakkr";
      desktopName = "Trakkr";
      categories = [
        "Game"
        "Utility"
      ];
      comment = meta.description;
      terminal = false;
    })
  ];

  meta = {
    description = "Mission tracking tool for Elite: Dangerous";
    longDescription = "Trakkr is specifically designed to assist Elite Dangerous missions, offering tailored support to enhance the efficiency and management of their operations.";
    homepage = "https://github.com/skybreakdigital/trakkr-app";
    changelog = "https://github.com/skybreakdigital/trakkr-app/releases/tag/v${version}";
    mainProgram = "Trakkr";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jiriks74 ];
  };
}
