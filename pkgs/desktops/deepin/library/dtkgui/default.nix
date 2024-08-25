{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  doxygen,
  libsForQt5,
  dtkcore,
  lxqt,
  librsvg,
}:

stdenv.mkDerivation rec {
  pname = "dtkgui";
  version = "5.6.32";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-F3tuLV1hWoUZle0O66MQ+Ew9LRnP6N++HaqS88xBLRY=";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    lxqt.libqtxdg
    librsvg
  ];

  propagatedBuildInputs = [
    dtkcore
    libsForQt5.qtimageformats
  ];

  cmakeFlags = [
    "-DDTK_VERSION=${version}"
    "-DBUILD_DOCS=ON"
    "-DMKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs/modules"
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
    for binary in $out/libexec/dtk5/DGui/bin/*; do
      wrapQtApp $binary
    done
  '';

  meta = with lib; {
    description = "Deepin Toolkit, gui module for DDE look and feel";
    homepage = "https://github.com/linuxdeepin/dtkgui";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
