{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, lxqt-build-tools
, qtbase
, qttools
, qtsvg
, kwindowsystem
, liblxqt
, libqtxdg
, lxqt-globalkeys
, qtx11extras
, menu-cache
, muparser
, pcre
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-runner";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-NGytLQ2D5t1UdMGZoeHxHaXPwbRFDx+11ocjImXqZBU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
  ];

  buildInputs = [
    qtbase
    qtsvg
    qtx11extras
    kwindowsystem
    liblxqt
    libqtxdg
    lxqt-globalkeys
    menu-cache
    muparser
    pcre
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-runner";
    description = "Tool used to launch programs quickly by typing their names";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
