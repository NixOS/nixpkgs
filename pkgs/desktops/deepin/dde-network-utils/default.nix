{ stdenv, fetchFromGitHub, qmake, pkgconfig, qttools,
  dde-qt-dbus-factory, proxychains, which, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dde-network-utils";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0c055bysmn1vk1blqh9x449v5981bcvnpnjzh5qnw1pywl8h0wzb";
  };

  nativeBuildInputs = [
    qmake
    pkgconfig
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    dde-qt-dbus-factory
    proxychains
    which
  ];

  postPatch = ''
    searchHardCodedPaths
    patchShebangs .
    fixPath ${proxychains} /usr/bin/proxychains4 networkworker.cpp
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "DDE network utils";
    homepage = https://github.com/linuxdeepin/dde-network-utils;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
