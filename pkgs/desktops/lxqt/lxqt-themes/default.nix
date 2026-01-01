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
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-themes";
    rev = version;
    hash = "sha256-sdfLwLYE29Qh0QCU6t5pKIyW2RYx32WRNvNV46nCaXo=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  passthru.updateScript = gitUpdater { };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/lxqt/lxqt-themes";
    description = "Themes, graphics and icons for LXQt";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lxqt ];
=======
  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-themes";
    description = "Themes, graphics and icons for LXQt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.lxqt ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
