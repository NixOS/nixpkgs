{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtk3, libxml2, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-calc-${version}";
  version = "1.20.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1ghz03j9lfgrjrh8givsw83dpbkw4wlhq4ar3r5g1bf1z636jlx0";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libxml2
  ];

  meta = with stdenv.lib; {
    description = "Calculator for the MATE desktop";
    homepage = http://mate-desktop.org;
    license = [ licenses.gpl2Plus ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
