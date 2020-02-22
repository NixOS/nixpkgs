{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qmake, dtkcore, dtkwidget,
  qt5integration, deepin }:

mkDerivation rec {
  pname = "deepin-menu";
  version = "3.4.8";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "09i0ybllymlj7s46pxma5py6x8nknfja4gxn5gj9kpf2c37qsqjc";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
    deepin.setupHook
  ];

  buildInputs = [
    dtkcore
    dtkwidget
    qt5integration
  ];

  postPatch = ''
    searchHardCodedPaths
    fixPath $out /usr \
      data/com.deepin.menu.service \
      deepin-menu.desktop \
      deepin-menu.pro
  '';

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Deepin menu service";
    homepage = https://github.com/linuxdeepin/deepin-menu;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
