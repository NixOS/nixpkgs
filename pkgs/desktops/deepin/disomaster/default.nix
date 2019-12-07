{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qmake, qtbase, libisoburn, deepin }:

mkDerivation rec {
  pname = "disomaster";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "13144gq0mpbpclzxc79fb1kirh0vvi50jvjnbpla9s8lvh59xl62";
  };

  nativeBuildInputs = [
    deepin.setupHook
    pkgconfig
    qmake
  ];

  buildInputs = [
    libisoburn
    qtbase
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging

    sed -i '/^QMAKE_PKGCONFIG_DESTDIR/i QMAKE_PKGCONFIG_PREFIX = $$PREFIX' \
       libdisomaster/libdisomaster.pro
  '';

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "A libisoburn wrapper for Qt";
    homepage = https://github.com/linuxdeepin/disomaster;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo worldofpeace ];
  };
}
