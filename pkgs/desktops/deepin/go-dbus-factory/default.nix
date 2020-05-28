{ stdenv
, fetchFromGitHub
, deepin
}:

stdenv.mkDerivation rec {
  pname = "go-dbus-factory";
  version = "1.7.0.6";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1l37a1cr6hmddfin8aiarmqc4d4x4jrvpjwh8h9xqndaw8xhaivf";
  };

  nativeBuildInputs = [
    deepin.setupHook
  ];

  makeFlags = [
    "GOSITE_DIR=${placeholder "out"}/share/go"
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging
  '';

  postFixup = ''
    searchHardCodedPaths $out  # debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Go DBus factory for the Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/go-dbus-factory";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
