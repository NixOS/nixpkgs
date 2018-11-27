{ stdenv, fetchFromGitHub, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "go-dbus-factory";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1vgpm3v0amjh2xb6cg9xpd7rikj3297h150b95qxrws1pjwm0m5v";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    sed -i -e 's:/share/gocode:/share/go:' Makefile
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "GoLang DBus factory for the Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/go-dbus-factory;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
