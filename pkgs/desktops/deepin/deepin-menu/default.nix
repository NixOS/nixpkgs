{ stdenv
, mkDerivation
, fetchFromGitHub
, pkg-config
, qmake
, dtkcore
, dtkgui
, dtkwidget
, qt5integration
, qtmultimedia
, qtx11extras
, deepin
}:

mkDerivation rec {
  pname = "deepin-menu";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0fqby41s0jph31g1hhq7v006k37z9q3q2xnd8aiy0rkriph7z5xd";
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
    qtmultimedia
    qtx11extras
  ];

  postPatch = ''
    searchHardCodedPaths
    fixPath $out /usr \
      data/com.deepin.menu.service \
      deepin-menu.desktop \
      deepin-menu.pro
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Deepin menu service";
    homepage = "https://github.com/linuxdeepin/deepin-menu";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
