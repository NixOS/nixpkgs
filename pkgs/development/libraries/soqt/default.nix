{ fetchurl, stdenv, coin3d, qt4, pkgconfig }:

stdenv.mkDerivation rec {
  name = "soqt-${version}";
  version = "1.5.0";

  src = fetchurl {
    url = "http://ftp.coin3d.org/coin/src/all/SoQt-${version}.tar.gz";
    sha256 = "14dbh8ynzjcgwgxjc6530c5plji7vn62kbdf447w0dp53564p8zn";
  };

  buildInputs = [ coin3d qt4 ];

  buildNativeInputs = [ pkgconfig ];

  meta = {
    homepage = http://www.coin3d.org/;
    license = "GPLv2+";
    description = "Glue between Coin high-level 3D visualization library and Qt";

    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
