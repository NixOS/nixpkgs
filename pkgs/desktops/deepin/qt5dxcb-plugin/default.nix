{ stdenv, fetchFromGitHub, pkgconfig, qmake, qtx11extras, libSM, mtdev, cairo }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qt5dxcb-plugin";
  version = "1.1.11";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "157p2cqs9fvd4n4fmxj6mh4cxlc35bkl4rnf832wk2gvjnxdfrfy";
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

  meta = with stdenv.lib; {
    description = "Qt platform theme integration plugin for DDE";
    homepage = https://github.com/linuxdeepin/qt5dxcb-plugin;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
