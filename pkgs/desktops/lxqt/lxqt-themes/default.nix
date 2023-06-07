{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-themes";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "bmkvg62lNFRhSerKFSo2POP8MWa1ZrdSi2E9nWDQSRQ=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-themes";
    description = "Themes, graphics and icons for LXQt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
