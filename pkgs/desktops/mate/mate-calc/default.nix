{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtk3, libxml2, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-calc";
  version = "1.22.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0zin3w03zrkpb12rvay23bfk9fnjpybkr5mqzkpn9xfnqamhk8ld";
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
    homepage = https://mate-desktop.org;
    license = [ licenses.gpl2Plus ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
