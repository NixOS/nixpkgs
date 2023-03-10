{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, lxqt-build-tools
, qtbase
, qttools
, qtx11extras
, qtsvg
, polkit
, polkit-qt
, kwindowsystem
, liblxqt
, libqtxdg
, pcre
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-policykit";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "SvJ4XN0JZs2VAt5H9CJXrJhThxnQnlbsLP44CW7zpGM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    polkit
    polkit-qt
    kwindowsystem
    liblxqt
    libqtxdg
    pcre
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-policykit";
    description = "The LXQt PolicyKit agent";
    mainProgram = "lxqt-policykit-agent";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
