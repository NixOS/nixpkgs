{ stdenv
, fetchFromGitHub
, deepin
}:

stdenv.mkDerivation rec {
  pname = "go-dbus-factory";
  version = "1.6.4.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0sg5nyc0s03lhmry8ilm914wrbq2qgsdvla7miba9nrg4gryl89f";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  postPatch = ''
    sed -i -e 's:/share/gocode:/share/go:' Makefile
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "GoLang DBus factory for the Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/go-dbus-factory";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
