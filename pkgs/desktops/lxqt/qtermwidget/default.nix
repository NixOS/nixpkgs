{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, qttools
, lxqt-build-tools
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "qtermwidget";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0i1w5wgac7r4p0jjrrswlvvwivkwrp1b88xh5ijjw6k9irjc7zf6";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/qtermwidget";
    description = "A terminal emulator widget for Qt 5";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
