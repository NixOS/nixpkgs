{ stdenv, fetchFromGitHub, pkgconfig, qmake, qtx11extras, libSM,
  mtdev, cairo, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qt5dxcb-plugin";
  version = "1.1.15";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0j3fxl7dl89cnharhlmzhgi43p1irvwv77l27gkfm4016hlxk45s";
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

  preConfigure = ''
    qmakeFlags="$qmakeFlags INSTALL_PATH=$out/$qtPluginPrefix/platforms"
  '';

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Qt platform theme integration plugin for DDE";
    homepage = https://github.com/linuxdeepin/qt5dxcb-plugin;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
