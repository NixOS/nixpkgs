{ fetchFromGitHub, lib, stdenv, boost, cmake, libX11, libGL, libGLU }:

stdenv.mkDerivation rec {
  pname = "coin";
  version = "2020-12-07-unstable";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "coin";
    # rev = "Coin-${version}";
    rev = "d5539998aff272b349590fe74d068659682ecd0d";
    sha256 = "11jaz8p9nn8jpd6dsgwgkldwr7z829gyf64g014qyyh8l6p7jzzd";
  };

  postPatch = ''
    sed -i /cpack.d/d CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost libX11 libGL libGLU ];

  meta = with lib; {
    homepage = "https://github.com/coin3d/coin";
    license = licenses.bsd3;
    description = "High-level, retained-mode toolkit for effective 3D graphics development";
    maintainers = with maintainers; [ gebner viric ];
    platforms = platforms.linux;
  };
}
