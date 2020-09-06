{ stdenv, lazarus, qt5 }:

stdenv.mkDerivation {
  pname = "libqt5pas";
  inherit (lazarus) version src;

  sourceRoot = "lazarus/lcl/interfaces/qt5/cbindings";

  postPatch = ''
    substituteInPlace Qt5Pas.pro \
      --replace "target.path = \$\$[QT_INSTALL_LIBS]" "target.path = $out/lib"
  '';

  nativeBuildInputs = with qt5; [ qmake ];

  buildInputs = with qt5; [ qtbase qtx11extras ];

  meta = with stdenv.lib; {
    description = "Free Pascal Qt5 binding library";
    homepage = "https://wiki.freepascal.org/Qt5_Interface#libqt5pas";
    maintainers = with maintainers; [ sikmir ];
    inherit (lazarus.meta) license platforms;
  };
}
