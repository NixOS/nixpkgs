{ stdenv, fetchFromGitHub, cmake, qt5, lxqt }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qterminal";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1899a5zc5kx7mxiyrncigqjia1k98qg526qynf4754nr9ifghxdw";
  };

  nativeBuildInputs = [
    cmake
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    lxqt.qtermwidget
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "A lightweight Qt-based terminal emulator";
    homepage = https://github.com/lxde/qterminal;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
