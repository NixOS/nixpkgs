{ stdenv, fetchurl, bison, libuuid, curl, libxml2, flex }:

stdenv.mkDerivation rec {
  version = "3.15.1";
  name = "libdap-${version}";

  buildInputs = [ bison libuuid curl libxml2 flex ];

  src = fetchurl {
    url = "http://www.opendap.org/pub/source/${name}.tar.gz";
    sha256 = "6ee13cc69ae0b5e7552ddfd17013ebb385859bba66f42a2cfba3b3be7aa4ef0f";
  };

  meta = { 
    description = "A C++ SDK which contains an implementation of DAP";
    homepage = http://www.opendap.org/download/libdap;
    license = stdenv.lib.licenses.lgpl2;
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    platforms = stdenv.lib.platforms.linux;
  };
}
