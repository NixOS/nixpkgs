{
  lib,
  stdenv,
  fetchFromGitHub,
  intltool,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  miniupnpc,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation {
  pname = "yaup";
  version = "0-unstable-2026-03-25";

  src = fetchFromGitHub {
    owner = "Holarse-Linuxgaming";
    repo = "yaup";
    rev = "7135987a17208dab1b980ba5de55114abe217b63";
    hash = "sha256-1P95cbGy8H+iXs/i7B4eTDzOPXJUJVBTOECsUZX9wG4=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Replace GNU ld's --export-dynamic with macOS linker equivalent
    substituteInPlace src/Makefile.in \
      --replace-fail '-Wl,--export-dynamic' '-Wl,-export_dynamic'
  '';

  nativeBuildInputs = [
    copyDesktopItems
    intltool
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    miniupnpc
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "yaup";
      desktopName = "Yaup";
      genericName = "UPnP Portmapper";
      comment = "Yet Another UPnP Portmapper";
      icon = "yaup";
      exec = "yaup";
      categories = [
        "Network"
        "Utility"
      ];
      keywords = [
        "Port forwarding"
      ];
    })
  ];

  postInstall = ''
    install -Dm644 src/yaup-dark.png $out/share/icons/hicolor/512x512/apps/yaup.png
  '';

  meta = {
    homepage = "https://github.com/Holarse-Linuxgaming/yaup";
    description = "Yet Another UPnP Portmapper";
    longDescription = ''
      Portmapping made easy.
      Portforward your incoming traffic to a specified local ip.
      Mostly used for IPv4.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
    mainProgram = "yaup";
  };
}
