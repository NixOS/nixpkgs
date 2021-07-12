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
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0pmkk2mba8z6cgfsd8sy4vhf5d9fn9hvxszzyycyy1ndygjrc1v8";
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
