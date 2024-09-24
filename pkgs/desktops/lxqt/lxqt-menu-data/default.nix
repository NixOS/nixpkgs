{ lib
, stdenv
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qttools
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "lxqt-menu-data";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-CNY23xdFiDQKKJf9GccwDOuBWXwfc7WNI7vMv/zOM9U=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
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
