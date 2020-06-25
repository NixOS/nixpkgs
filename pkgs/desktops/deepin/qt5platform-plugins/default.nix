{ stdenv
, mkDerivation
, fetchFromGitHub
, fetchpatch
, pkg-config
, qmake
, cairo
, deepin
, libSM
, mtdev
, qtbase
, qtwayland
, qtx11extras
}:

mkDerivation rec {
  pname = "qt5platform-plugins";
  version = "5.0.15";

  srcs = [
    (fetchFromGitHub {
      owner = "linuxdeepin";
      repo = pname;
      rev = version;
      sha256 = "1hmg86rfc8g4q1sdljd0wh66w9a2j9x3rvq0bzsk8xvv9im8kgmp";
    })
    qtbase.src
  ];

  sourceRoot = "source";

  nativeBuildInputs = [
    pkg-config
    qmake
    deepin.setupHook
  ];

  buildInputs = [
    cairo
    libSM
    mtdev
    qtbase
    qtwayland
    qtx11extras
  ];

  postPatch = ''
    searchHardCodedPaths  # debuging

    # The Qt5 platforms plugin is vendored in the package, however what is there is not always up-to-date with what is in nixpkgs.
    # We simply link the headers from qtbase's source tarball.
    ln -sr ../qtbase-everywhere-src-${qtbase.version}/src/plugins/platforms/xcb xcb/libqt5xcbqpa-dev/${qtbase.version}

    # Disable wayland for now: https://github.com/linuxdeepin/qt5platform-plugins/issues/47
    sed -i '/wayland/d' qt5platform-plugins.pro
  '';

  qmakeFlags = [
    "INSTALL_PATH=${placeholder "out"}/${qtbase.qtPluginPrefix}/platforms"
  ];

  postFixup = ''
    searchHardCodedPaths -a $out  # debuging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version; src = (builtins.head srcs); };

  meta = with stdenv.lib; {
    description = "Qt platform theme integration plugin for DDE";
    homepage = "https://github.com/linuxdeepin/qt5platform-plugins";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
