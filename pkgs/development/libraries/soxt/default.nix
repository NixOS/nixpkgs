{ fetchurl, stdenv, coin3d, motif, xlibsWrapper, libGLU_combined }:

stdenv.mkDerivation rec {
  name = "soxt-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "https://bitbucket.org/Coin3D/coin/downloads/SoXt-${version}.tar.gz";
    sha256= "f5443aadafe8e2222b9b5a23d1f228bb0f3e7d98949b8ea8676171b7ea5bf013";
  };

  buildInputs = [ coin3d motif xlibsWrapper libGLU_combined ];

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/Coin3D/coin/wiki/Home;
    license = licenses.bsd3;
    description = "A GUI binding for using Open Inventor with Xt/Motif";
    maintainers = with maintainers; [ tmplt ];
    platforms = platforms.linux;
  };
}
