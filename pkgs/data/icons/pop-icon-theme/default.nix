{ lib
, stdenvNoCC
, fetchFromGitHub
, meson
, ninja
, gtk3
, adwaita-icon-theme
, hicolor-icon-theme
}:

stdenvNoCC.mkDerivation rec {
  pname = "pop-icon-theme";
  version = "2021-11-17";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "icon-theme";
    rev = "9998b20b78f3ff65ecbf2253bb863d1e669abe74";
    sha256 = "0lwdmaxs9xj4bm21ldh64bzyb6iz5d5k1256iwvyjp725l7686cl";
  };

  nativeBuildInputs = [
    meson
    ninja
    gtk3
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  meta = with lib; {
    description = "Icon theme for Pop!_OS with a semi-flat design and raised 3D motifs";
    homepage = "https://github.com/pop-os/icon-theme";
    license = with licenses; [ cc-by-sa-40 gpl3 ];
    platforms = platforms.linux; # hash mismatch on darwin due to file names differing only in case
    maintainers = with maintainers; [ romildo ];
  };
}
