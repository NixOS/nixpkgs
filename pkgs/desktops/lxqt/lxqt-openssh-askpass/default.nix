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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1uBgP4cOKypZZbMVYdvgM7GyZI2Ef3XmuAfs0nPzHd0=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
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
  };
}
