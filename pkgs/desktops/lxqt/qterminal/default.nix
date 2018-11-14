{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtermwidget, qt5 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qterminal";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1z9wlyj5i192jfq3dcxjf8wzx9x332f19c9ll7zv69cq21kyy9wn";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    qtermwidget
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "A lightweight Qt-based terminal emulator";
    homepage = https://github.com/lxqt/qterminal;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
