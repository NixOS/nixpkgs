{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_9,
  makeWrapper,
  electron_27,
  nodejs_18,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
  commandLineArgs ? "",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thedesk";
  version = "25.0.15";

  src = fetchFromGitHub {
    owner = "cutls";
    repo = "thedesk-next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-41uDThFA1U5cig9z5bCs4q50cNNs7Z7rz3bvFkdnWy0=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-KVfkB54oj4DSDUQ2HxmDV9juIYt4+8mAfrbJtu/M3Is=";
  };

  nativeBuildInputs = [
    nodejs_18
    pnpm_9.configHook
    copyDesktopItems
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    cp -r node_modules/.pnpm/jsonfile@6.1.0/node_modules/jsonfile node_modules/jsonfile
    cp -r node_modules/.pnpm/universalify@2.0.1/node_modules/universalify node_modules/universalify
    cp -r node_modules/.pnpm/mkdirp@1.0.4/node_modules/mkdirp node_modules/mkdirp
    cp -r node_modules/.pnpm/app-root-path@3.1.0/node_modules/app-root-path node_modules/app-root-path
    pnpm run thirdparty
    pnpm run build-renderer
    pnpm run build-electron
    pnpm exec electron-builder --linux --dir \
      -c.electronDist="${electron_27}/libexec/electron" \
      -c.electronVersion=${electron_27.version}

    runHook postBuild
  '';

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  desktopItems = [
    (makeDesktopItem {
      name = "thedesk";
      desktopName = "TheDesk";
      exec = "thedesk %U";
      terminal = false;
      icon = "thedesk";
      startupWMClass = "TheDesk";
      categories = [ "Utility" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/thedesk
    cp -r dist/linux-unpacked/{resources,LICENSE*} $out/lib/thedesk
    install -Dm644 assets/desk.png $out/share/pixmaps/thedesk.png
    makeWrapper "${lib.getExe electron_27}" $out/bin/thedesk \
      --inherit-argv0 \
      --add-flags $out/lib/thedesk/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mastodon/Misskey Client for PC";
    homepage = "https://thedesk.top";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "thedesk";
  };
})
