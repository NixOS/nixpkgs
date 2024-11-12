{ lib
, stdenv
, fetchFromGitHub
, cmake
, kwindowsystem
, liblxqt
, libqtxdg
, lxqt-build-tools
, qtbase
, qtsvg
, qttools
, qtwayland
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "qps";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-FJw1J4c8oLBo7adl1uhCuS+o/ZhJAOyLmbjUgtdt0ss=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    liblxqt
    libqtxdg
    qtbase
    qtsvg
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/qps";
    description = "Qt based process manager";
    mainProgram = "qps";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux; # does not build on darwin
    maintainers = teams.lxqt.members;
  };
}
