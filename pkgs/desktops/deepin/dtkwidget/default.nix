{ stdenv
, mkDerivation
, fetchFromGitHub
, pkg-config
, qmake
, qttools
, qtmultimedia
, qtsvg
, qtx11extras
, librsvg
, libstartup_notification
, gsettings-qt
, dde-qt-dbus-factory
, dtkgui
, deepin
}:

mkDerivation rec {
  pname = "dtkwidget";
  version = "5.2.2.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "02p6dd3skwflbmcw2qbfm2y597h7pdnknhsqj3k840isx7hi8hbv";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    qtmultimedia
    qtsvg
    qtx11extras
    librsvg
    libstartup_notification
    gsettings-qt
    dde-qt-dbus-factory
  ];

  propagatedBuildInputs = [
    dtkgui
  ];

  qmakeFlags = [
    "MKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs"
    "QMAKE_PKGCONFIG_PREFIX=${placeholder "out"}"
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging
  '';

  postFixup = ''
    wrapQtApp $out/lib/libdtk-*/DWidget/bin/dtk-svgc
    searchHardCodedPaths $out  # debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Deepin graphical user interface library";
    homepage = "https://github.com/linuxdeepin/dtkwidget";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
