{ fetchurl, stdenv, coin3d, qtbase, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "soqt";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/coin3d/soqt/releases/download/SoQt-${version}/soqt-${version}-src.tar.gz";
    sha256 = "07qfljy286vb7y1p93205zn9sp1lpn0rcrqm5010gj87kzsmllwz";
  };

  buildInputs = [ coin3d qtbase ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/coin3d/soqt";
    license = licenses.bsd3;
    description = "Glue between Coin high-level 3D visualization library and Qt";
    maintainers = with maintainers; [ gebner viric ];
    platforms = platforms.linux;
  };
}
