{ stdenv, fetchFromGitHub, qmake, qtdeclarative }:

stdenv.mkDerivation rec {
  name = "qml-box2d-${version}";
  version = "2018-04-06";

  src = fetchFromGitHub {
    owner  = "qml-box2d";
    repo   = "qml-box2d";
    rev    = "b7212d5640701f93f0cd88fbd3a32c619030ae62";
    sha256 = "0gb8limy6ck23z3k0k2j7c4c4s95p40f6lbzk4szq7fjnnw22kb7";
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [ qtdeclarative ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace box2d.pro \
      --replace '$$[QT_INSTALL_QML]' "/$qtQmlPrefix/"
    qmakeFlags="$qmakeFlags PREFIXSHORTCUT=$out"
    '';

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = with stdenv.lib; {
    description = "A QML plugin for the Box2D engine";
    homepage = https://github.com/qml-box2d/qml-box2d;
    license = licenses.zlib;
    maintainers = with maintainers; [ guibou ];
    platforms = platforms.linux;
  };
}
