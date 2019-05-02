{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtk3, libxml2, libgtop, libcanberra-gtk3, inkscape, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-utils-${version}";
  version = "1.22.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0768y6x33ljc9dxjlfmvplsn4lrxj5xhjddbyab9h6pqav8527rg";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    inkscape
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libgtop
    libcanberra-gtk3
    libxml2
    mate.mate-panel
    hicolor-icon-theme
  ];

  meta = with stdenv.lib; {
    description = "Utilities for the MATE desktop";
    homepage = https://mate-desktop.org;
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
