{ lib
, stdenv
, fetchFromGitHub
, cmake
, kidletime
, kwindowsystem
, liblxqt
, libqtxdg
, lxqt-build-tools
, lxqt-globalkeys
, qtbase
, qtsvg
, qttools
, qtwayland
, solid
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "lxqt-powermanagement";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-wtqVUXYQWIPhvHj7Ig9qR6sglCRQzcxG192DM3xq/mA=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kidletime
    kwindowsystem
    liblxqt
    libqtxdg
    lxqt-globalkeys
    qtbase
    qtsvg
    qtwayland
    solid
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-powermanagement";
    description = "Power management module for LXQt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
