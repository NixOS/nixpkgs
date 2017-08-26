{ stdenv, fetchurl, cmake, qt4, pkgconfig, gsasl }:

stdenv.mkDerivation rec {
  name = "libjreen-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "https://qutim.org/dwnl/73/${name}.tar.bz2";
    sha256 = "14nwwk40xx8w6x7yaysgcr0lgzhs7l064f7ikp32s5y9a8mmp582";
  };

  buildInputs = [ cmake qt4 pkgconfig gsasl ];
  enableParallelBuilding = true;

  meta = {
    description = "C++ Jabber library using Qt framework";
    homepage = https://qutim.org/jreen/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
