{ stdenv
, mkDerivation
, fetchFromGitHub
, pkg-config
, qmake
, dtkcore
, dtkgui
, dtkwidget
, qt5integration
, deepin
}:

mkDerivation rec {
  pname = "deepin-shortcut-viewer";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0wgfbpf90xgl78q526gdn6cpnrkkr6a2d0axgabnijs608i9wfpc";
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
    qt5integration
  ];

  postPatch = ''
    searchHardCodedPaths # debugging
  '' ;

  postFixup = ''
    searchHardCodedPaths $out # debugging
  '' ;

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Pop-up shortcut viewer for Deepin applications";
    homepage = "https://github.com/linuxdeepin/deepin-shortcut-viewer";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
