{ stdenv, fetchFromGitHub, pkgconfig, cmake, qtbase, qttools,
  qtwebchannel, dtkcore, dtkwidget, qt5integration, qcef, libsass,
  sqlite, gtk2, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-manual";
  version = "2.0.19";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "09pjvv2c0h4yzvcghv37f5rl47p4dh2bkbpwc63x7gavx3m1m203";
  };

  nativeBuildInputs = [
    pkgconfig
    cmake
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    dtkcore
    dtkwidget
    gtk2 # ? listed in archlinux
    libsass
    qcef
    qt5integration
    qtbase
    qtbase.bin  # ? lib/qt-5.12/plugins/sqldrivers/libqsqlite.so
    qtwebchannel
    sqlite # ?
  ];

  postPatch = ''
    searchHardCodedPaths
    echo ----------------------------------
    patchShebangs .
    echo ----------------------------------
    grep -r 'search\.db'
    echo ----------------------------------
    grep -ir 'SQLITE'
    echo ----------------------------------
  '';

  preBuild = ''
    echo ==================================
    grep -r 'search\.db'
    echo ==================================
    find -name search.db -ls
    echo ==================================
  '';

  postFixup = ''
    searchHardCodedPaths $out
  '';

  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "Deepin user manual";
    homepage = https://github.com/linuxdeepin/deepin-manual;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
