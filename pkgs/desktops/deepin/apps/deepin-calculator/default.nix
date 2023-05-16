{ stdenv
, lib
, fetchFromGitHub
, dtkwidget
, qt5integration
, qt5platform-plugins
, qtbase
, qtsvg
, dde-qt-dbus-factory
, cmake
, qttools
, pkg-config
, wrapQtAppsHook
, gtest
}:

stdenv.mkDerivation rec {
  pname = "deepin-calculator";
<<<<<<< HEAD
  version = "5.8.24";
=======
  version = "5.8.23";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Gv4X1vT3w3kd1FN6BBpUeG2VBz/e+OWLBQyBL7r3BrI=";
=======
    sha256 = "sha256-MczQWYIQfpSkyA3144y3zly66N0vgcVvTYR6B7Hq1aw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5integration
    qt5platform-plugins
    qtbase
    qtsvg
    dde-qt-dbus-factory
    gtest
  ];

  strictDeps = true;

  cmakeFlags = [ "-DVERSION=${version}" ];

  meta = with lib; {
    description = "An easy to use calculator for ordinary users";
    homepage = "https://github.com/linuxdeepin/deepin-calculator";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
