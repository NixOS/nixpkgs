{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qmake, qtx11extras, libSM,
  mtdev, cairo, deepin, qtbase }:

mkDerivation rec {
  pname = "qt5dxcb-plugin";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1zvab6qxdr49pmk6mbk7s0md7bx585p32lca0xbg8mrkajz7g8rq";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
  ];

  buildInputs = [
    qtx11extras
    libSM
    mtdev
    cairo
  ];

  qmakeFlags = [
    "INSTALL_PATH=${placeholder "out"}/${qtbase.qtPluginPrefix}/platforms"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { inherit ;name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Qt platform theme integration plugin for DDE";
    homepage = https://github.com/linuxdeepin/qt5dxcb-plugin;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
