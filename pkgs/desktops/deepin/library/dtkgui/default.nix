{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, cmake
, qttools
, doxygen
, wrapQtAppsHook
, qtbase
, dtkcore
, qtimageformats
, lxqt
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "dtkgui";
  version = "5.6.29";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-TSU6sqdwBa86k7HcyNSJeJ6gj+n6EfIMjE8skSG5o0c=";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch
  ];

  nativeBuildInputs = [
    cmake
    qttools
    doxygen
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    lxqt.libqtxdg
    librsvg
  ];

  propagatedBuildInputs = [
    dtkcore
    qtimageformats
  ];

  cmakeFlags = [
    "-DDTK_VERSION=${version}"
    "-DBUILD_DOCS=ON"
    "-DMKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs/modules"
    "-DQCH_INSTALL_DESTINATION=${placeholder "doc"}/${qtbase.qtDocPrefix}"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${qtbase.bin}/${qtbase.qtPluginPrefix}
  '';

  outputs = [ "out" "dev" "doc" ];

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
