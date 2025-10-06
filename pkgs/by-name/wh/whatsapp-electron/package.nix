{
  lib,
  fetchFromGitHub,
  makeWrapper,
  electron,
  stdenv,
  copyDesktopItems,
  nodejs,
  fetchNpmDeps,
  makeDesktopItem,
  npmHooks,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "whatsapp";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "dagmoller";
    repo = "whatsapp-electron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i3rk/wAr2MtJqXv7Z9uG0YzIsvaxrDvcXsXQhDEmzxw=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-5AlnAtxiQDbJEbxthGT8DQhZG5tdkrFk0+47czalnlU=";
  };

  patches = [ ./icon.patch ];

  nativeBuildInputs = [
    makeWrapper
    nodejs
    npmHooks.npmConfigHook
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ copyDesktopItems ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  buildPhase = ''
    runHook preBuild

    npm install
    ./node_modules/.bin/electron-builder \
      --dir \
      -c.electronDist=${if stdenv.hostPlatform.isDarwin then "." else electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/whatsapp-electron"
    cp -r dist/*-unpacked/{locales,resources{,.pak}} "$out/share/whatsapp-electron"

    install -D assets/whatsapp-icon-512x512.png $out/share/pixmaps/whatsapp.png
    install -D assets/whatsapp-icon-512x512.svg $out/share/icons/hicolor/scalable/apps/whatsapp.svg
    runHook postInstall
  '';

  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    makeWrapper ${electron}/bin/electron $out/bin/whatsapp-electron \
      --add-flags $out/share/whatsapp-electron/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "com.github.dagmoller.whatsapp-electron";
      exec = "whatsapp-electron %u";
      icon = "whatsapp";
      desktopName = "Whatsapp";
      startupWMClass = "com.github.dagmoller.whatsapp-electron";
      categories = [
        "Network"
        "InstantMessaging"
      ];
    })
  ];

  meta = {
    description = "Electron wrapper around Whatsapp";
    homepage = "https://github.com/dagmoller/whatsapp-electron";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      rucadi
    ];
    mainProgram = "whatsapp-electron";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
