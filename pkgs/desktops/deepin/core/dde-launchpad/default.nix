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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-8m0DjQYih3hB/n2VHuJgUYBe8tpGwBU0NdkLxr1OsFc=";
  };

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
    homepage = "https://github.com/linuxdeepin/dde-launchpad";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
