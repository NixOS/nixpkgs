{ fetchhg, stdenv, cmake, doxygen, coin3d, qt5 }:

stdenv.mkDerivation rec {
  name = "soqt-${version}";
  version = "20190306";

  src = fetchhg {
    url = "https://bitbucket.org/Coin3D/soqt";
    rev = "67a51c8fddbd9b93b855d0b24448f512b7a3bdda";
    sha256 = "0b3hmjgylx37145nqd067qci564xbqr5w2wv9a2gv2zz86n8k8p9";
    fetchSubrepos = true;
  };

  patches = [ ./interface_include.patch ];

  nativeBuildInputs = [ cmake doxygen ];
  buildInputs = [ coin3d qt5.qtbase ];

  meta = with stdenv.lib; {
    description = "Glue between Coin high-level 3D visualization library and Qt";
    homepage = https://bitbucket.org/Coin3D/coin/wiki/Home;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.viric maintainers.FlorianFranzen ];
    platforms = platforms.linux;
  };
}
