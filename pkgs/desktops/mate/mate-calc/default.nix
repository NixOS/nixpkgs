{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtk3, libxml2, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-calc-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "1h6kr9qb1kaw8jvfm7xmqm1wqnxsw2iwha5vl38b986x4zm2b712";
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
