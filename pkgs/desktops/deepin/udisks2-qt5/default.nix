{ stdenv
, mkDerivation
, fetchFromGitHub
, qmake
, qtbase
, deepin
}:

mkDerivation rec {
  pname = "udisks2-qt5";
  version = "5.0.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1d6qdcwp0n6f2ipn90n9m7biaims2kk1nljidw9h1myrqf3bfm4k";
  };

  nativeBuildInputs = [
    deepin.setupHook
    qmake
  ];

  buildInputs = [
    qtbase
  ];

  postPatch = ''
    searchHardCodedPaths # debugging
  '';

  qmakeFlags = [
    "QMAKE_PKGCONFIG_PREFIX=${placeholder "out"}"
  ];

  postFixup = ''
    searchHardCodedPaths $out # debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "UDisks2 D-Bus interfaces binding for Qt5";
    homepage = "https://github.com/linuxdeepin/udisks2-qt5";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
