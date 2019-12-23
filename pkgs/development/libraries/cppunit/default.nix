{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "cppunit";
  version = "1.15.0";

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/${pname}-${version}.tar.gz";
    sha256 = "08j9hc11yl07ginsf282pshn6zpy96yhzf7426sfn10f8gdxyq8w";
  };

  meta = with stdenv.lib; {
    homepage = https://freedesktop.org/wiki/Software/cppunit/;
    description = "C++ unit testing framework";
    license = licenses.lgpl21;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
