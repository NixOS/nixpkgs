{stdenv, fetchurl, openssl}:

stdenv.mkDerivation rec {
  name = "mysocketw-031026";
  src = fetchurl {
    url = http://www.digitalfanatics.org/cal/socketw/files/SocketW031026.tar.gz;
    sha256 = "0crinikhdl7xihzmc3k3k41pgxy16d5ci8m9sza1lbibns7pdwj4";
  };

  patches = [ ./gcc.patch ];

  configurePhase = ''
    sed -i s,/usr/local,$out, Makefile.conf
  '';

  buildInputs = [ openssl ];

  meta = {
    description = "Cross platform (Linux/FreeBSD/Unix/Win32) streaming socket C++";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.all;
  };
}
