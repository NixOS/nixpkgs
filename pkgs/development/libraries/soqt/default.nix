{ fetchFromGitHub, lib, stdenv, coin3d, qtbase, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "soqt";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "soqt";
    rev = "v${version}";
    sha256 = "sha256-lR1AiXAmkBFndroijRV6E0NLpyiNRfSCrcO+RJdBkZE=";
    fetchSubmodules = true;
  };

  buildInputs = [ coin3d qtbase ];

  nativeBuildInputs = [ cmake pkg-config ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/coin3d/soqt";
    license = licenses.bsd3;
    description = "Glue between Coin high-level 3D visualization library and Qt";
    maintainers = with maintainers; [ gebner viric ];
    platforms = platforms.linux;
  };
}
