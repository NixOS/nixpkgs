{ lib
, stdenvNoCC
, fetchurl
, meson
, ninja
, gettext
, mateUpdateScript
}:

stdenvNoCC.mkDerivation rec {
  pname = "mate-backgrounds";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "UNGv0CSGvQesIqWmtu+jAxFI8NSKguSI2QmtVwA6aUM=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
  ];

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Background images and data for MATE";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus cc-by-sa-40 ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
