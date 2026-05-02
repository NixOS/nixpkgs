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
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-themes";
    rev = version;
    hash = "sha256-whMW4fMiIcL4Qb/VNynVGBTIyObTMlf6AaWCnBYikZI=";
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
