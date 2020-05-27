{ stdenv
, mkDerivation
, fetchFromGitHub
, pkg-config
, qmake
, mtdev
, lxqt
, qtx11extras
, qtmultimedia
, qtsvg
, qt5platform-plugins
, qtstyleplugins
, dtkcore
, dtkgui
, dtkwidget
, deepin
}:

mkDerivation rec {
  pname = "qt5integration";
  version = "5.1.0.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0ir3dkf1xr92pnmcnxbp43s87wp9fnf6ia7xifls3xqf5msz0mmv";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    deepin.setupHook
  ];

  buildInputs = [
    dtkcore
    dtkgui
    dtkwidget
    qt5platform-plugins
    mtdev
    lxqt.libqtxdg
    qtstyleplugins
    qtx11extras
    qtmultimedia
    qtsvg
  ];

  postPatch = ''
    searchHardCodedPaths # debugging

    # # TODO: use path from dde-file-manager package (which may cause mutual dependences)
    # substituteInPlace platformthemeplugin/qdeepinfiledialoghelper.cpp \
    #   --replace /usr/bin/dde-file-manager dde-file-manager

    for f in $(grep -lr QT_INSTALL_PLUGINS); do
      substituteInPlace "$f" --replace '$$[QT_INSTALL_PLUGINS]' "$out/$qtPluginPrefix"
    done
  '';

  postFixup = ''
    searchHardCodedPaths $out # debugging
  '' ;

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Qt platform theme integration plugins for DDE";
    homepage = "https://github.com/linuxdeepin/qt5integration";
    license = with licenses; [ gpl3 lgpl2Plus bsd2 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
