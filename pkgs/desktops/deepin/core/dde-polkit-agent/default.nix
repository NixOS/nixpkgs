{ stdenv
, lib
, fetchFromGitHub
, dtkwidget
, qt5integration
, qt5platform-plugins
, dde-qt-dbus-factory
, pkg-config
, cmake
, qttools
, wrapQtAppsHook
, polkit-qt
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "dde-polkit-agent";
  version = "6.0.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-NSMwNL4ttCaqo0h0sF11bOJ20FhOB+SG27K4k8F4O/o=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5platform-plugins
    dde-qt-dbus-factory
    polkit-qt
  ];

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
  ];

  postFixup = ''
    wrapQtApp $out/lib/polkit-1-dde/dde-polkit-agent
  '';

  meta = with lib; {
    description = "PolicyKit agent for Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/dde-polkit-agent";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
