{ stdenv
, mkDerivation
, fetchFromGitHub
, qmake
, qtbase
, deepin
}:

mkDerivation rec {
  pname = "udisks2-qt5";
  version = "5.0.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0c87ks9glwhk4m2s7kf7mb43q011yi6l3qjq2ammmfqwl8xal69a";
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
