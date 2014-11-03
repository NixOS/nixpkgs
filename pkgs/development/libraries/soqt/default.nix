{ fetchurl, stdenv, coin3d, qt4, pkgconfig }:

stdenv.mkDerivation rec {
  name = "soqt-${version}";
  version = "1.5.0";

  src = fetchurl {
    url = "https://bitbucket.org/Coin3D/coin/downloads/SoQt-${version}.tar.gz";
    sha256 = "14dbh8ynzjcgwgxjc6530c5plji7vn62kbdf447w0dp53564p8zn";
  };

  buildInputs = [ coin3d qt4 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = http://www.coin3d.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Glue between Coin high-level 3D visualization library and Qt";

    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
