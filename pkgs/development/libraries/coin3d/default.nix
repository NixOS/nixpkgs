{ fetchhg, stdenv, cmake, doxygen, boost, xorg, libGLU_combined }:

stdenv.mkDerivation rec {
  name = "coin3d-${version}";
  version = "20190306";

  src = fetchhg {
    url = "https://bitbucket.org/Coin3D/coin";
    rev = "88065d49f47c613fef3a713cf23d4ca821196565";
    sha256 = "05hgav2p3plssvzb0zk074289n1lfyfbvcv9zsmlgbz00r77hppw";
    fetchSubrepos = true;
  };

  nativeBuildInputs = [ cmake doxygen ];
  buildInputs = [ boost xorg.libX11 libGLU_combined ];

  # libCoin.so.80: cannot open shared object file: No such file or directory
  #doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.coin3d.org/;
    license = licenses.gpl2Plus;
    description = "High-level, retained-mode toolkit for effective 3D graphics development";
    maintainers = [ maintainers.viric maintainers.FlorianFranzen ];
    platforms = platforms.linux;
  };
}
