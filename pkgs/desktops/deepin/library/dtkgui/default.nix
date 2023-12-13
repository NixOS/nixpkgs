{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
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
, freeimage
, libraw
}:

stdenv.mkDerivation rec {
  pname = "dtkgui";
  version = "5.6.17";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-ssCVMFCE1vhucYMxXkEZV5YlFxT1JdYGqrzILhWX1XI=";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch

    (fetchpatch {
      name = "fix_svg_with_filter_attribute_rendering_exception.patch";
      url = "https://github.com/linuxdeepin/dtkgui/commit/f2c9327eb4989ab8ea96af7560c67d1cada794de.patch";
      hash = "sha256-lfg09tgS4vPuYachRbHdaMYKWdZZ0lP0Hxakkr9JKGs=";
    })
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
    freeimage
    libraw
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
    "-DCMAKE_INSTALL_LIBEXECDIR=${placeholder "dev"}/libexec"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${qtbase.bin}/${qtbase.qtPluginPrefix}
  '';

  outputs = [ "out" "dev" "doc" ];

  meta = with lib; {
    description = "Deepin Toolkit, gui module for DDE look and feel";
    homepage = "https://github.com/linuxdeepin/dtkgui";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
