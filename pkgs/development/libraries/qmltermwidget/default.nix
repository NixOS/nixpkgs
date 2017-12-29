{ stdenv, fetchgit, qtbase, qtquick1, qmake, qtmultimedia }:

stdenv.mkDerivation rec {
  version = "0.1.0";
  name = "qmltermwidget-${version}";

  src = fetchgit {
    url = "https://github.com/Swordfish90/qmltermwidget.git";
    rev = "refs/tags/v${version}";
    sha256 = "0ca500mzcqglkj0i6km0z512y3a025dbm24605xyv18l6y0l2ny3";
  };

  buildInputs = [ qtbase qtquick1 qtmultimedia ];
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
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ skeidel ];
  };
}
