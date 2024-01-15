{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qttools
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-menu-data";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-I9jb2e57ZBvND27F5C1zMaoFtij5TetmN9zbJSjxiS4=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-menu-data";
    description = "Menu files for LXQt Panel, Configuration Center and PCManFM-Qt/libfm-qt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
