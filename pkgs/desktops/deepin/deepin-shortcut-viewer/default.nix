{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qmake, dtkcore, dtkwidget,
  qt5integration, deepin }:

mkDerivation rec {
  pname = "deepin-shortcut-viewer";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "13vz8kjdqkrhgpvdgrvwn62vwzbyqp88hjm5m4rcqg3bh56709ma";
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

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { inherit ;name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Pop-up shortcut viewer for Deepin applications";
    homepage = https://github.com/linuxdeepin/deepin-shortcut-viewer;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
