{ stdenv, fetchFromGitHub, pkgconfig, qmake, dtkcore, dtkwidget,
  qt5integration, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-menu";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "15v2v7pg53csxmhmnkglxv5mj9cpn0ph8kv3hj44973sdwyrl51f";
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

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Deepin menu service";
    homepage = https://github.com/linuxdeepin/deepin-menu;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
