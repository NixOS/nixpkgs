{ stdenv
, mkDerivation
, fetchFromGitHub
, pkg-config
, qmake
, dtkcore
, librsvg
, qtx11extras
, deepin
}:

mkDerivation rec {
  pname = "dtkgui";
  version = "5.2.2.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0d9f6q4dfl0h3jv36srjyghaj4j0hf28br1xnz0rag6a8qs28ciw";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    deepin.setupHook
  ];

  buildInputs = [
    librsvg
    qtx11extras
  ];

  propagatedBuildInputs = [
    dtkcore
  ];

  qmakeFlags = [
    "MKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs"
    "QMAKE_PKGCONFIG_PREFIX=${placeholder "out"}"
  ];

  postPatch = ''
    searchHardCodedPaths  # for debugging

    # fix systembusconf path
    fixPath $out /etc src/src.pro
  '';

  postFixup = ''
    wrapQtApp $out/lib/libdtk-*/DGui/bin/deepin-gui-settings
    wrapQtApp $out/lib/libdtk-*/DGui/bin/taskbar
    searchHardCodedPaths $out  # for debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Gui module for DDE look and feel";
    homepage = "https://github.com/linuxdeepin/dtkgui";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
