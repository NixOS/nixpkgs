{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_22,
  pnpm_11,
  electron_42,
  pnpmConfigHook,
  fetchPnpmDeps,
  makeBinaryWrapper,
  makeDesktopItem,
  copyDesktopItems,
  pkg-config,
  wayland,
  wayland-scanner,
  wayland-protocols,
  nix-update-script,
}:
let
  nodejs = nodejs_22;
  pnpm = pnpm_11;
  electron = electron_42; # upstream is on electron 41, but that's EOL
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wfhelper";
  version = "2.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "WFHelper";
    repo = "wfhelper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7epz9TbZJ9Y+Mo1dfggwxbQ/GagHVAxH4+FAglXoEc0=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-Hmbc0/Q1wDKysP6FvP1RnMdfMHG8yfDQLHGwCh9sdQI=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    makeBinaryWrapper
    copyDesktopItems
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run verify:onnx-models
    pnpm run build
    node scripts/build-layer-shell.mjs --require
    pnpm exec electron-builder --dir \
      -c.electronDist='${electron.dist}' \
      -c.electronVersion='${electron.version}'

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    libdir="$out/share/lib/wfhelper"
    mkdir -p "$libdir"
    cp -r release/linux-unpacked/{resources/,locales/} "$libdir"

    install -Dm444 assets/logo.png $out/share/icons/hicolor/974x974/apps/wfhelper.png

    makeBinaryWrapper '${lib.getExe electron}' "$out/bin/wfhelper" \
      --add-flags "$libdir/resources/app.asar" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "wfhelper";
      desktopName = "WFHelper";
      exec = "wfhelper %U";
      terminal = false;
      type = "Application";
      icon = "wfhelper";
      startupWMClass = "wfhelper";
      comment = "Warframe companion: inventory, foundry, relic and riven scanning, market orders.";
      categories = [ "Utility" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://wfhelper.com/";
    description = "Open source Warframe companion";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      mithicspirit
    ];
    mainProgram = "wfhelper";
  };
})
