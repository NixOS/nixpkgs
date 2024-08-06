{ stdenv
, lib
, fetchFromGitHub
, nixosTests
, dtkwidget
, qt5integration
, qt5platform-plugins
, cmake
, qtbase
, qtsvg
, qttools
, qtx11extras
, pkg-config
, wrapQtAppsHook
, libsecret
, chrpath
, lxqt
}:

stdenv.mkDerivation rec {
  pname = "deepin-terminal";
  version = "6.0.13";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-7+NJyqOp+9CHqdpBKx91RQNk1Z8vMQQqZcyKC5RSDjg=";
  };

  cmakeFlags = [ "-DVERSION=${version}" ];

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
    lxqt.lxqt-build-tools_0_13
  ];

  buildInputs = [
    qt5integration
    qt5platform-plugins
    qtbase
    qtsvg
    dtkwidget
    qtx11extras
    libsecret
    chrpath
  ];

  strictDeps = true;

  passthru.tests.test = nixosTests.terminal-emulators.deepin-terminal;

  meta = with lib; {
    description = "Terminal emulator with workspace, multiple windows, remote management, quake mode and other features";
    mainProgram = "deepin-terminal";
    homepage = "https://github.com/linuxdeepin/deepin-terminal";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
