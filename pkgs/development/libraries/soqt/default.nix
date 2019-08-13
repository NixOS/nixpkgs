{ fetchhg, stdenv, coin3d, qt5, cmake, pkgconfig }:

stdenv.mkDerivation {
  pname = "soqt";
  version = "1.6.0a";

  src = fetchhg {
    url = "https://bitbucket.org/Coin3D/soqt";
    rev = "5f2afb4890e0059eb27e1671f980d10ebfb9e762";
    sha256 = "0j9lsci4cx95v16l0jaky0vzh4lbdliwz7wc17442ihjaqiqmv8m";
    fetchSubrepos = true;
  };

  buildInputs = [ coin3d qt5.qtbase ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = {
    homepage = https://bitbucket.org/Coin3D/coin/wiki/Home;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Glue between Coin high-level 3D visualization library and Qt";

    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
