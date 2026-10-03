{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  sassc,
  pkg-config,
  glib,
  ninja,
  python3,
  gtk3,
  gnome,
  gnome-themes-extra,
}:

stdenv.mkDerivation rec {
  pname = "yaru-remix";
  version = "40";

  src = fetchFromGitHub {
    owner = "Muqtxdir";
    repo = "yaru-remix";
    rev = "v${version}";
    hash = "sha256-jADkbQ+RGgGIiNBG3dKnAh1uuAXy9R4B8l739QqHNHY=";
  };

  nativeBuildInputs = [
    meson
    sassc
    pkg-config
    glib
    ninja
    python3
  ];
  buildInputs = [
    gtk3
    gnome-themes-extra
  ];

  dontDropIconThemeCache = true;

  postPatch = "patchShebangs .";

  meta = {
    description = "Fork of the Yaru GTK theme";
    homepage = "https://github.com/Muqtxdir/yaru-remix";
    license = with lib.licenses; [
      cc-by-sa-40
      gpl3Plus
      lgpl21Only
      lgpl3Only
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ hoppla20 ];
  };
}
