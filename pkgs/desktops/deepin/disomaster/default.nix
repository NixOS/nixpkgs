{ stdenv
, mkDerivation
, fetchFromGitHub
, pkgconfig
, qmake
, qtbase
, libisoburn
, deepin
}:

mkDerivation rec {
  pname = "disomaster";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1kmhlnw37pdmlf7k9zry657xlhz40m9nzg361kiyisn186pfqpws";
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
  '';

  qmakeFlags = [
    "QMAKE_PKGCONFIG_PREFIX=${placeholder "out"}"
  ];

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "A libisoburn wrapper for Qt";
    homepage = "https://github.com/linuxdeepin/disomaster";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo worldofpeace ];
  };
}
