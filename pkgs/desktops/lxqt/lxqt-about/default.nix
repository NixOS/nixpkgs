{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qtx11extras
, qttools
, qtsvg
, kwindowsystem
, liblxqt
, libqtxdg
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-about";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "Dm4WFtF0O7MgAvwYBI/1DkY9MhneI+QSM+wRp4JlD+o=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtx11extras
    qttools
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-about";
    description = "Dialogue window providing information about LXQt and the system it's running on";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
