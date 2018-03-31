{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtk3, libxml2, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-calc-${version}";
  version = "1.20.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "00k063ia4dclvcpg1q733lbi56533s6mj8bgb1nrgna6y7zw4q87";
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
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
