{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lxqt-build-tools,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-themes";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-oarj+byRfe9xHvtw80kifA2AspXHfigbuDwvi5xqrMQ=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/lxqt-themes";
    description = "Themes, graphics and icons for LXQt";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lxqt ];
  };
}
