{ fetchFromGitHub, stdenv, boost, cmake, libGL, libGLU }:

stdenv.mkDerivation rec {
  pname = "coin";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "coin";
    rev = "Coin-${version}";
    sha256 = "1ayg0hl8wanhadahm5xbghghxw1qjwqbrs3dl3ngnff027hsyf8p";
  };

  postPatch = ''
    sed -i /cpack.d/d CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost libGL libGLU ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/coin3d/coin";
    license = licenses.bsd3;
    description = "High-level, retained-mode toolkit for effective 3D graphics development";
    maintainers = with maintainers; [ gebner viric ];
    platforms = platforms.linux;
  };
}
