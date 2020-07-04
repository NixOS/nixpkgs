{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qtermwidget
, qtbase
, qttools
, qtx11extras
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "qterminal";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1vna0fvdasrdx7l5zxaaxi1v9fy34g2qblgkdhpczxivnmmxm5a3";
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

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "A lightweight Qt-based terminal emulator";
    homepage = "https://github.com/lxqt/qterminal";
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo globin ];
  };
}
