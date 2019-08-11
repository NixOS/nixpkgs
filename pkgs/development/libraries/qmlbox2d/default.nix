{stdenv, qtdeclarative, fetchFromGitHub, qmake }:
stdenv.mkDerivation rec {
  name = "qml-box2d-2018-04-06";
  src = fetchFromGitHub {
    owner = "qml-box2d";
    repo = "qml-box2d";
    sha256 = "0gb8limy6ck23z3k0k2j7c4c4s95p40f6lbzk4szq7fjnnw22kb7";
    rev = "b7212d5640701f93f0cd88fbd3a32c619030ae62";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ qmake ];

  buildInputs = [ qtdeclarative ];

  patchPhase = ''
    substituteInPlace box2d.pro \
      --replace '$$[QT_INSTALL_QML]' "/$qtQmlPrefix/"
    qmakeFlags="$qmakeFlags PREFIXSHORTCUT=$out"
    '';

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = with stdenv.lib; {
    description = "A QML plugin for Box2D engine";
    homepage = "https://github.com/qml-box2d/qml-box2d";
    maintainers = [ maintainers.guibou ];
    platforms = platforms.linux;
    license = licenses.zlib;
  };
}
