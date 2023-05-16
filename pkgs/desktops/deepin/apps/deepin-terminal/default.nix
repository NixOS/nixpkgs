{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
<<<<<<< HEAD
, nixosTests
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, dtkwidget
, qt5integration
, qt5platform-plugins
, dde-qt-dbus-factory
, cmake
, qtbase
, qtsvg
, qttools
, qtx11extras
, pkg-config
, wrapQtAppsHook
, at-spi2-core
, libsecret
, chrpath
, lxqt
}:

stdenv.mkDerivation rec {
  pname = "deepin-terminal";
<<<<<<< HEAD
  version = "6.0.6";
=======
  version = "6.0.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-LzCbh+BErgh7Ojbw314oHB8QvyS6UeJkDUkNngzVm+A=";
=======
    sha256 = "sha256-pRTdvR3hyiJVpi38Ex58X74ns+rSWuytsOXemvdW1Rk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cmakeFlags = [ "-DVERSION=${version}" ];

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qt5integration
    qt5platform-plugins
    qtbase
    qtsvg
    dtkwidget
    dde-qt-dbus-factory
    qtx11extras
    at-spi2-core
    libsecret
    chrpath
  ];

  strictDeps = true;

<<<<<<< HEAD
  passthru.tests.test = nixosTests.terminal-emulators.deepin-terminal;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Terminal emulator with workspace, multiple windows, remote management, quake mode and other features";
    homepage = "https://github.com/linuxdeepin/deepin-terminal";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
