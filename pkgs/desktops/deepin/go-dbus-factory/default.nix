{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "go-dbus-factory";
  version = "0.0.7.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0gj2xxv45gh7wr5ry3mcsi46kdsyq9nbd7znssn34kapiv40ixcx";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with stdenv.lib; {
    description = "GoLang DBus factory for the Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/go-dbus-factory;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
