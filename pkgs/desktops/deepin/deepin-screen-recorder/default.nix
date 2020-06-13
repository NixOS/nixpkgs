{ stdenv
, mkDerivation
, fetchFromGitHub
, pkg-config
, qmake
, dde-qt-dbus-factory
, dtkcore
, dtkgui
, dtkwidget
, libXtst
, libxcb
, procps
, qtmultimedia
, qttools
, qtx11extras
, deepin
}:

mkDerivation rec {
  pname = "deepin-screen-recorder";
  version = "5.8.0.11";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1wn6qf8mf4bmr37psf63nbfh6d3v57vyqrmj50mil9cpsypcynah";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    dde-qt-dbus-factory
    dtkcore
    dtkgui
    dtkwidget
    libXtst
    libxcb
    procps
    qtmultimedia
    qtx11extras
  ];

  postPatch = ''
    searchHardCodedPaths
    fixPath $out /etc screen_shot_recorder.pro
    fixPath $out /usr screen_shot_recorder.pro
  '';

  postFixup = ''
    searchHardCodedPaths $out
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Calendar for Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/deepin-screen-recorder";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
