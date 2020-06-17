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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "07wvcc650998yav9hr4hpm842j0iqdvls3mn9n2n4v8xvm7cii2m";
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
    description = "A terminal emulator widget for Qt 5";
    homepage = "https://github.com/lxqt/qtermwidget";
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
