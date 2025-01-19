{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kidletime,
  kwindowsystem,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  lxqt-globalkeys,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  solid,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-powermanagement";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-S60m8ixz6HnTZe0MTyvU0pXWWOS88KeXfDcQJ/I1Keo=";
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

  meta = {
    homepage = "https://github.com/lxqt/lxqt-powermanagement";
    description = "Power management module for LXQt";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.lxqt.members;
  };
}
