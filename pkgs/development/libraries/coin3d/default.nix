{ fetchFromBitbucket, stdenv, boost, cmake, libGLU_combined }:

stdenv.mkDerivation {
  pname = "coin";
  version = "unstable-2019-06-12";

  src = fetchFromBitbucket {
    owner = "Coin3D";
    repo = "coin";
    rev = "8d860d7ba112b22c4e9b289268fd8b3625ab81d3";
    sha256 = "1cpncljqvw28k5wvpgchv593nayhby5gwpvbnyllc9hb9ms816xn";
  };

  postPatch = ''
    sed -i /cpack.d/d CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost libGLU_combined ];

  meta = {
    homepage = "https://bitbucket.org/Coin3D/coin/wiki/Home";
    license = stdenv.lib.licenses.gpl2Plus;
    description = "High-level, retained-mode toolkit for effective 3D graphics development";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
