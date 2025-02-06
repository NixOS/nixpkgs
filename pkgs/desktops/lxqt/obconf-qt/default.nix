{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libSM,
  libXdmcp,
  libpthreadstubs,
  lxqt-build-tools,
  openbox,
  pcre,
  pkg-config,
  qtbase,
  qttools,
  qtwayland,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "obconf-qt";
  version = "0.16.5";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "obconf-qt";
    rev = version;
    hash = "sha256-C7s312DeLiustPBBY4OdjYvN7X6noktLA8LuhlOaVRo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    libSM
    libXdmcp
    libpthreadstubs
    openbox
    pcre
    qtbase
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/obconf-qt";
    description = "Qt port of obconf, the Openbox configuration tool";
    mainProgram = "obconf-qt";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = lib.teams.lxqt.members;
  };
}
