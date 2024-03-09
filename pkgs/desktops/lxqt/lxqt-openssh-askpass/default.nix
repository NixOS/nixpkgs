{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qtbase
, qttools
, qtsvg
, qtx11extras
, kwindowsystem
, liblxqt
, libqtxdg
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-openssh-askpass";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-o/hJdaGtjcJiwjqfvfwfcOUv4YdAeeW+rCxsmZZdJQ0=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
  ];

  buildInputs = [
    qtbase
    qtx11extras
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-openssh-askpass";
    description = "GUI to query passwords on behalf of SSH agents";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
    mainProgram = "lxqt-openssh-askpass";
  };
}
