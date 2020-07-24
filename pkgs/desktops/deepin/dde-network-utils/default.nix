{ stdenv
, mkDerivation
, fetchFromGitHub
, substituteAll
, qmake
, pkgconfig
, qttools
, dde-qt-dbus-factory
, proxychains
, which
, deepin
}:

mkDerivation rec {
  pname = "dde-network-utils";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0670kfnkplf7skkd1ql6y9x15kmrcbdv1005qwkg4vn8hic6s0z3";
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

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit which proxychains;
    })
  ];

  postPatch = ''
    searchHardCodedPaths  # for debugging
    patchShebangs translate_generation.sh
  '';

  postFixup = ''
    searchHardCodedPaths $out  # for debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Deepin network utils";
    homepage = "https://github.com/linuxdeepin/dde-network-utils";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
