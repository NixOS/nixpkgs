{
  lib,
  rustPlatform,
  fetchFromGitHub,
  copyDesktopItems,
  pkg-config,
  glib,
  gtk3,
  openssl,
  wayland,
  xdotool,
  makeDesktopItem,
  libayatana-appindicator,
  imagemagick,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "windsend-rs";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "doraemonkeys";
    repo = "WindSend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zpbCtiGPjGLkcZ98uN0y0modMnhucV4g4Sc9P6cRPIw=";
  };

  cargoHash = "sha256-iQLklhJDZllL380UorUSKS4vQxBHKVFr6lmxhEta3CY=";

  sourceRoot = "${finalAttrs.src.name}/windSend-rs";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    imagemagick
  ];

  buildInputs = [
    glib
    gtk3
    openssl
    wayland
    xdotool
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "windsend-rs";
      exec = "wind_send";
      icon = "windsend-rs";
      desktopName = "WindSend";
    })
  ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/128x128/apps
    magick icon-192.png -resize 128x128 $out/share/icons/hicolor/128x128/apps/windsend-rs.png
  '';

  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath [ libayatana-appindicator ]} $out/bin/wind_send
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Quickly and securely sync clipboard, transfer files and directories between devices";
    homepage = "https://github.com/doraemonkeys/WindSend";
    mainProgram = "wind_send";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
