{
  lib,
  electron,
  zip,
  nodejs_24,
  makeWrapper,
  udev,
  usbutils,
  freerdp,
  docker-compose,
  pkgsCross,
  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:
buildNpmPackage (final: {
  pname = "winboat";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "TibixDev";
    repo = "winboat";
    tag = "v${final.version}";
    hash = "sha256-30WzvdY8Zn4CAj76bbC0bevuTeOSfDo40FPWof/39Es=";
  };

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "main/main.js" "src/main/main.ts"
  '';

  nativeBuildInputs = [
    zip
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [ udev ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  npmDepsHash = "sha256-nW+cGX4Y0Ndn1ubo4U3n8ZrjM5NkxIt4epB0AghPrNQ=";
  nodejs = nodejs_24;
  makeCacheWritable = true;

  guest-server = pkgsCross.mingwW64.callPackage ./guest-server.nix { };
  passthru = {
    guest-server = final.guest-server;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "guest-server"
      ];
    };
  };

  buildPhase = ''
    node scripts/build.ts
    npm exec electron-builder --linux -- \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false
  '';

  installPhase = ''
    runHook preInstall

    # install built artifacts
    mkdir -p $out/bin $out/share/winboat
    cp -r dist/linux-unpacked/resources $out/share/winboat/resources

    # install winboat icon
    install -Dm444 icons/icon.png $out/share/icons/hicolor/256x256/apps/winboat.png

    # copy the the winboat-guest-server executable and generate the zip
    cp ${lib.getExe final.guest-server} $out/share/winboat/resources/guest_server/winboat_guest_server.exe
    (cd $out/share/winboat/resources/guest_server/ && zip -r winboat_guest_server.zip .)

    # symlink data/ and guest_server/ into parent folder
    ln -sf $out/share/winboat/resources/data $out/share/winboat/data
    ln -sf $out/share/winboat/resources/guest_server $out/share/winboat/guest_server

    makeWrapper ${electron}/bin/electron $out/bin/winboat \
      --add-flag "$out/share/winboat/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --suffix PATH : ${
        lib.makeBinPath [
          usbutils
          docker-compose
          freerdp
        ]
      }

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "winboat";
      desktopName = "WinBoat";
      type = "Application";
      exec = "winboat %U";
      terminal = false;
      icon = "winboat";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    mainProgram = "winboat";
    description = "Run Windows apps on Linux with seamless integration";
    homepage = "https://github.com/TibixDev/winboat";
    changelog = "https://github.com/TibixDev/winboat/releases/tag/v${final.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rexies
      ppom
    ];
    platforms = [ "x86_64-linux" ];
  };
})
