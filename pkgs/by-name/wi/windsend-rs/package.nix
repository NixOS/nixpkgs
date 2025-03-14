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
  version = "1.4.10";

  src = fetchFromGitHub {
    owner = "doraemonkeys";
    repo = "WindSend";
    tag = "v${version}";
    hash = "sha256-gDqn06Gv//1CdSfBwKj8WCVcRC2o8GigEfrYeZqWceA=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-Yi5SC5yEH8OW1PO6r+SD/vfcOEpJ7B5mJ+/7pFL6UEY=";

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
    maintainers = with lib.maintainers; [ nayeko ];
    platforms = lib.platforms.linux;
  };
}
