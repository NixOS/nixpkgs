{ stdenv, fetchurl, lib, glib }:

with lib;

stdenv.mkDerivation rec {
  name = "libutempter-${version}";
  version = "1.1.6";

  src = fetchurl {
    url = "http://archive.ubuntu.com/ubuntu/pool/main/libu/libutempter/libutempter_${version}.orig.tar.bz2";
    sha256 = "15y3xbgznjxnfmix4xg3bwmqdvghdw7slbhazb0ybmyf65gmd65q";
  };

  buildInputs = [ glib ];

  installFlags = [
    "libdir=\${out}/lib"
    "libexecdir=\${out}/lib"
    "includedir=\${out}/include"
    "mandir=\${out}/share/man"
  ];

  meta = {
    description = "Interface for terminal emulators such as screen and xterm to record user sessions to utmp and wtmp files";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
