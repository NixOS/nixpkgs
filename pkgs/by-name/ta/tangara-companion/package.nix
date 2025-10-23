{
  lib,
  rustPlatform,
  fetchFromGitHub,

  copyDesktopItems,
  makeDesktopItem,

  gdk-pixbuf,
  glib,
  graphene,
  gtk4,
  libadwaita,
  pango,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "tangara-companion";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "haileys";
    repo = "tangara-companion";
    tag = "v${version}";
    hash = "sha256-x/xB+itr1GVcaTEre3u6Lchg9VcSzWiNyWVGv5Aczgw=";
  };

  cargoHash = "sha256-PVTfAG2AOioW1zVXtXB5SBJX2sJoWVRQO3NafUOAleo=";

  nativeBuildInputs = [
    copyDesktopItems
    glib
    pkg-config
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    graphene
    gtk4
    libadwaita
    pango
    udev
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "tangara-companion";
      desktopName = "Tangara Companion";
      comment = meta.description;
      type = "Application";
      exec = meta.mainProgram;
      terminal = false;
      categories = [
        "Utility"
        "GTK"
      ];
      icon = "tangara-companion";
      startupNotify = true;
    })
  ];

  postInstall = ''
    install -Dm644 $src/data/assets/icon.svg $out/share/icons/hicolor/scalable/apps/tangara-companion.svg
  '';

  meta = {
    description = "Companion app for Cool Tech Zone Tangara";
    mainProgram = "tangara-companion";
    homepage = "https://github.com/haileys/tangara-companion";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ benpye ];
    platforms = lib.platforms.linux;
  };
}
