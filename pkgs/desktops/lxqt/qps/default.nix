{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, kwindowsystem
, liblxqt
, libqtxdg
, lxqt-build-tools
, gitUpdater
, qtbase
, qttools
, qtx11extras
}:

mkDerivation rec {
  pname = "qps";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-Xr+61t6LzoXASHuXrE5ro3eWGxMSDCVnck49dCtiaww=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
  ];

  buildInputs = [
    kwindowsystem
    liblxqt
    libqtxdg
    qtbase
    qtx11extras
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/qps";
    description = "Qt based process manager";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux; # does not build on darwin
    maintainers = teams.lxqt.members;
  };
}
