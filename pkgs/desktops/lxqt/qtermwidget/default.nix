{ stdenv
, lib
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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "tb1Vlkv8HsNlFCFOYfPnJlhdJmhyDmLE9SaTXZT0gGs=";
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
    broken = stdenv.isDarwin;
    homepage = "https://github.com/lxqt/qtermwidget";
    description = "A terminal emulator widget for Qt 5";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
