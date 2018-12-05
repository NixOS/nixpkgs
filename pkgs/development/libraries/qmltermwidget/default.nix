{ stdenv, fetchFromGitHub, qtbase, qtquick1, qmake, qtmultimedia, utmp }:

stdenv.mkDerivation rec {
  version = "0.1.0";
  name = "qmltermwidget-${version}";

  src = fetchFromGitHub {
    repo = "qmltermwidget";
    owner = "Swordfish90";
    rev = "v${version}";
    sha256 = "0ca500mzcqglkj0i6km0z512y3a025dbm24605xyv18l6y0l2ny3";
  };

  buildInputs = [ qtbase qtquick1 qtmultimedia ]
                ++ stdenv.lib.optional stdenv.isDarwin utmp;
  nativeBuildInputs = [ qmake ];

  patchPhase = ''
    substituteInPlace qmltermwidget.pro \
      --replace '$$[QT_INSTALL_QML]' "/$qtQmlPrefix/"
  '';

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  enableParallelBuilding = true;

  meta = {
    description = "A QML port of qtermwidget";
    homepage = https://github.com/Swordfish90/qmltermwidget;
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ skeidel ];
  };
}
