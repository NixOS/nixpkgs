{
  lib,
  go,
  electron,
  zip,
  nodejs_24,
  makeWrapper,
  udev,
  usbutils,
  freerdp,
  docker-compose,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  writableTmpDirAsHomeHook,
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
    makeWrapper
    copyDesktopItems
    zip
    go
    writableTmpDirAsHomeHook
  ];

  buildInputs = [ udev ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  npmDepsHash = "sha256-nW+cGX4Y0Ndn1ubo4U3n8ZrjM5NkxIt4epB0AghPrNQ=";
  nodejs = nodejs_24;
  makeCacheWritable = true;

  guestDrv = buildGoModule {
    inherit (final) version src;
    modRoot = "guest_server";
    pname = "winboat-server";
    vendorHash = "sha256-JglpTv1hkqxmcbD8xmG80Sukul5hzGyyANfe+GeKzQ4=";
  };

  buildPhase = ''
    node scripts/build.ts
    npm exec electron-builder --linux -- \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false

    # build the go guest_server executable
    export GOOS=windows
    export GOARCH=amd64
    export PACKAGE=winboat-server
    export BUILD_TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S')
    export LDFLAGS=(
      "-X 'main.Version=${final.version}'"
      "-X 'main.CommitHash=${final.src.rev}'"
      "-X 'main.BuildTimestamp=''${BUILD_TIMESTAMP}'"
    )

    ln -sf "${final.guestDrv.goModules}" guest_server/vendor
    (cd guest_server && go build -ldflags="''${LDFLAGS[*]}" -o winboat_guest_server.exe *.go)
  '';

  installPhase = ''
    runHook preInstall

    # install built artifacts
    mkdir -p $out/bin $out/share/winboat
    cp -r dist/linux-unpacked/* $out/share/winboat

    # install the icon
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp icons/icon.png $out/share/icons/hicolor/256x256/apps/winboat.png

    # copy the the winboat-guest-server executable and generate the zip
    cp guest_server/winboat_guest_server.exe $out/share/winboat/resources/guest_server/
    (cd $out/share/winboat/resources/guest_server/ && zip -r winboat_guest_server.zip .)

    # copy data and guest_server into parent folder
    cp -r $out/share/winboat/resources/data $out/share/winboat/data
    cp -r $out/share/winboat/resources/guest_server $out/share/winboat/guest_server

    makeWrapper ${electron}/bin/electron $out/bin/winboat \
      --add-flag "$out/share/winboat/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --suffix PATH : ${
        lib.makeBinPath [
          usbutils
          docker-compose
          freerdp
        ]
      } \
      ''${gappsWrapperArgs[@]}

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
