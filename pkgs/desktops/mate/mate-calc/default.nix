{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtk3, libxml2, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-calc-${version}";
  version = "1.21.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "07mmc99wwgqbp15zrr6z7iz0frc388z19jwk28ymyzgn6bcc9cn6";
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
