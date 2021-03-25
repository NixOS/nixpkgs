{ lib, stdenv, fetchurl, pkg-config, gettext, itstool, gtk3, libxml2, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-calc";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0imdimq5d5rjq8mkjcrsd683a2bn9acmhc0lmvyw71y0040inbaw";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libxml2
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Calculator for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
