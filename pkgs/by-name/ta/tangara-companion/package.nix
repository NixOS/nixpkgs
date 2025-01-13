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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "haileys";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-pTE+xlXWIOOt1oiKosnbXTCLYoAqP3CfXA283a//Ds0=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-C7Q3Oo/aBBH6pW1zSFQ2nD07+wu8uXfRSwNif2pVlW0=";

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
      name = pname;
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
