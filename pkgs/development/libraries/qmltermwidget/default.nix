{ stdenv, fetchFromGitHub, qtbase, qtquick1, qmake, qtmultimedia, utmp }:

stdenv.mkDerivation rec {
  version = "2018-11-24";
  name = "qmltermwidget-unstable-${version}";

  src = fetchFromGitHub {
    repo = "qmltermwidget";
    owner = "Swordfish90";
    rev = "48274c75660e28d44af7c195e79accdf1bd44963";
    sha256 = "028nb1xp84jmakif5mmzx52q3rsjwckw27jdpahyaqw7j7i5znq6";
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
