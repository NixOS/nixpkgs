{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  wayland,
  openssl,
  glib,
  gtk3,
  xdotool,
  libayatana-appindicator,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "windsend-rs";
  version = "1.4.10.1";

  src = fetchFromGitHub {
    owner = "doraemonkeys";
    repo = "WindSend";
    tag = "v${version}";
    hash = "sha256-141NrtQofrtJB+tBA9fWhcHqN/a+0eG16voKlA2DIGA=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-y+67yvWBC9Qzhe4DOhm9I9NUud4xeZ+nztG4bph/otE=";

  sourceRoot = "${src.name}/windSend-rs";

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    wayland
    openssl
    glib
    gtk3
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
    install -Dm644 icon-192.png $out/share/pixmaps/windsend-rs.png
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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
