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
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0mdcz45faj9ysw725qzg572968kf5sh6zfw7iiksi26s8kiyhbbp";
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
    homepage = "https://github.com/lxqt/qterminal";
    description = "A lightweight Qt-based terminal emulator";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo globin ];
  };
}
