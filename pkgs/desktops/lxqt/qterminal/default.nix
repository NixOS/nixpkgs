{ lib, mkDerivation, fetchFromGitHub, cmake, lxqt-build-tools, qtermwidget,
  qtbase, qttools, qtx11extras }:

mkDerivation rec {
  pname = "qterminal";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0bq6lvns56caijdmjm05nsj9vg69v9x5vid24bfxasck6q8nw24w";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtermwidget
  ];

  meta = with lib; {
    description = "A lightweight Qt-based terminal emulator";
    homepage = https://github.com/lxqt/qterminal;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo globin ];
  };
}
