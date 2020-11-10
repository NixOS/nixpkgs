{ stdenv, fetchurl, pkgconfig, gettext, itstool, glib, gtk3, libxml2, libgtop, libcanberra-gtk3, inkscape, udisks2, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-utils";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1b16n1628gcsym5mph6lr9x5xm4rgkxsa8xwr2wlx8g2gw2775i1";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    itstool
    inkscape
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libgtop
    libcanberra-gtk3
    libxml2
    udisks2
    mate.mate-panel
    hicolor-icon-theme
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Utilities for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
