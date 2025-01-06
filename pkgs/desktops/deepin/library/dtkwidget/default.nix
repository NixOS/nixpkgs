{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  doxygen,
  libsForQt5,
  dtkgui,
  cups,
  gsettings-qt,
  libstartup_notification,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "dtkwidget";
  version = "5.6.31";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-FAF66FsmUX0dhFlbT5wAUWkxY0TOU6dcKNwlY10Qou0=";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch
  ];

  postPatch = ''
    substituteInPlace src/widgets/dapplication.cpp \
      --replace "auto dataDirs = DStandardPaths::standardLocations(QStandardPaths::GenericDataLocation);" \
                "auto dataDirs = DStandardPaths::standardLocations(QStandardPaths::GenericDataLocation) << \"$out/share\";"
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
    libsForQt5.qtsvg
    libsForQt5.qtx11extras
    cups
    gsettings-qt
    libstartup_notification
    xorg.libXdmcp
  ];

  propagatedBuildInputs = [ dtkgui ];

  cmakeFlags = [
    "-DDTK_VERSION=${version}"
    "-DBUILD_DOCS=ON"
    "-DMKSPECS_INSTALL_DIR=${placeholder "dev"}/mkspecs/modules"
    "-DQCH_INSTALL_DESTINATION=${placeholder "doc"}/${libsForQt5.qtbase.qtDocPrefix}"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${libsForQt5.qtbase.bin}/${libsForQt5.qtbase.qtPluginPrefix}
  '';

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  postFixup = ''
    for binary in $out/lib/dtk5/DWidget/bin/*; do
        wrapQtApp $binary
    done
  '';

  meta = with lib; {
    description = "Deepin graphical user interface library";
    homepage = "https://github.com/linuxdeepin/dtkwidget";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
