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
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "windsend-rs";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "doraemonkeys";
    repo = "WindSend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u82VmMuc7+tbc1Qgs5lbyFlNTauJm6E9KFXPHBdTryA=";
  };

  cargoHash = "sha256-dn6O2cCOPInktrKrcZBwN2FwmKUjm3crCL6yhIPQj/Y=";

  sourceRoot = "${finalAttrs.src.name}/windSend-rs";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
