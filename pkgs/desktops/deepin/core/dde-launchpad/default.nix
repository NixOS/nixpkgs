{ stdenv
, lib
, fetchFromGitHub
, cmake
, qttools
, pkg-config
, wrapQtAppsHook
, dtkwidget
, dtkdeclarative
, qtbase
, appstream-qt
, kitemmodels
, qt5integration
}:

stdenv.mkDerivation rec {
  pname = "dde-launchpad";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-az8BC3n44NGpATNu3Exjn3H7Rumx/YqDXztEGqCpAbY=";
  };

  postPatch = ''
    substituteInPlace desktopintegration.cpp \
      --replace "AppStreamQt/pool.h" "AppStreamQt5/pool.h"
  '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    dtkdeclarative
    qtbase
    appstream-qt
    kitemmodels
  ];

  cmakeFlags = [
    "-DSYSTEMD_USER_UNIT_DIR=${placeholder "out"}/lib/systemd/user"
  ];

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
  ];

  meta = with lib; {
    description = "The 'launcher' or 'start menu' component for DDE";
    mainProgram = "dde-launchpad";
    homepage = "https://github.com/linuxdeepin/dde-launchpad";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
