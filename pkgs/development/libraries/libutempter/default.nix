{ stdenv, fetchurl, lib, glib }:

with lib;

stdenv.mkDerivation rec {
  pname = "libutempter";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://ubuntu/pool/main/libu/libutempter/libutempter_${version}.orig.tar.bz2";
    sha256 = "15y3xbgznjxnfmix4xg3bwmqdvghdw7slbhazb0ybmyf65gmd65q";
  };

  buildInputs = [ glib ];

  patches = [ ./exec_path.patch ];

  prePatch = ''
    substituteInPlace Makefile --replace 2711 0711
  '';

  makeFlags = [
    "libdir=\${out}/lib"
    "libexecdir=\${out}/lib"
    "includedir=\${out}/include"
    "mandir=\${out}/share/man"
  ];

  meta = {
    description = "Interface for terminal emulators such as screen and xterm to record user sessions to utmp and wtmp files";
    longDescription = ''
      The bundled utempter binary must be able to run as a user belonging to group utmp.
      On NixOS systems, this can be achieved by creating a setguid wrapper.
    '';
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
