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
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0kpg4b60h6dads8ncwlk0zj1c8y7xpb0kz28j0v9fqjbmxja7x6w";
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
