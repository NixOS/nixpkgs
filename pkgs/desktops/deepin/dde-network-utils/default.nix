{ stdenv
, mkDerivation
, fetchFromGitHub
, substituteAll
, qmake
, pkg-config
, qttools
, dde-qt-dbus-factory
, gsettings-qt
, proxychains
, which
, deepin
}:

mkDerivation rec {
  pname = "dde-network-utils";
  version = "6.1.0101.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "11vllzq0v8nns6lzi44b4318m5jwcgahhv7hfap56zjiibqyzfwm";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    dde-qt-dbus-factory
    gsettings-qt
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
