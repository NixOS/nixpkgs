{ stdenv, fetchFromGitHub, cmake, qt5, kde5, lxqt }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qterminal";
  version = "0.7.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1g8d66h8avk094wvgqw0mgl9caamdig6bnn4vawshn4j7y8g4n7v";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
    lxqt.qtermwidget
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "A lightweight Qt-based terminal emulator";
    homepage = https://github.com/lxde/qterminal;
    license = licenses.gpl2;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
