{ stdenv, fetchFromGitHub, pkgconfig, qmake, dtkcore, dtkwidget,
  qt5integration }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-menu";
  version = "3.3.10";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1666821c2irs2hjgr3kvivij6c2fgjva8323kplrz75w2lz518xb";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
  ];

  buildInputs = [
    dtkcore
    dtkwidget
    qt5integration
  ];

  postPatch = ''
    sed -i deepin-menu.pro -e "s,/usr,$out,"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Deepin menu service";
    homepage = https://github.com/linuxdeepin/deepin-menu;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
