{ lib, stdenv, fetchFromGitHub, meson, sassc, pkg-config, glib, ninja, python3, gtk3, gnome }:

stdenv.mkDerivation rec {
  pname = "yaru-remix";
  version = "40";

  src = fetchFromGitHub {
    owner = "Muqtxdir";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xilhw5gbxsyy80ixxgj0nw6w782lz9dsinhi24026li1xny804c";
  };

  nativeBuildInputs = [ meson sassc pkg-config glib ninja python3 ];
  buildInputs = [ gtk3 gnome.gnome-themes-extra ];

  dontDropIconThemeCache = true;

  postPatch = "patchShebangs .";

  meta = with lib; {
    description = "Fork of the Yaru GTK theme";
    homepage = "https://github.com/Muqtxdir/yaru-remix";
    license = with licenses; [ cc-by-sa-40 gpl3Plus lgpl21Only lgpl3Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ hoppla20 ];
  };
}
