{ stdenv
, mkDerivation
, fetchFromGitHub
, pkgconfig
, qmake
, qtx11extras
, libSM
, mtdev
, cairo
, deepin
, qtbase
}:

mkDerivation rec {
  pname = "qt5platform-plugins";
  version = "5.0.11";

  srcs = [
    (fetchFromGitHub {
      owner = "linuxdeepin";
      repo = pname;
      rev = version;
      sha256 = "14xkr3p49716jc9v7ksj6jgcmfa65qicqrmablizfi71srg3z2pr";
    })
    qtbase.src
  ];

  sourceRoot = "source";

  nativeBuildInputs = [
    pkgconfig
    qmake
  ];

  buildInputs = [
    qtx11extras
    libSM
    mtdev
    cairo
    qtbase
  ];

  postPatch = ''
    # The Qt5 platforms plugin is vendored in the package, however what's there is not always up-to-date with what's in nixpkgs.
    # We simply copy the headers from qtbase's source tarball.
    mkdir -p platformplugin/libqt5xcbqpa-dev/${qtbase.version}
    cp -r ../qtbase-everywhere-src-${qtbase.version}/src/plugins/platforms/xcb/*.h platformplugin/libqt5xcbqpa-dev/${qtbase.version}/
  '';

  qmakeFlags = [
    "INSTALL_PATH=${placeholder "out"}/${qtbase.qtPluginPrefix}/platforms"
  ];

  passthru.updateScript = deepin.updateScript { inherit pname version; src = (builtins.head srcs); };

  meta = with stdenv.lib; {
    description = "Qt platform theme integration plugin for DDE";
    homepage = "https://github.com/linuxdeepin/qt5platform-plugins";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
