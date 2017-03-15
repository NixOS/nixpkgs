{ stdenv, fetchurl, bison, libuuid, curl, libxml2, flex }:

stdenv.mkDerivation rec {
  version = "3.18.3";
  name = "libdap-${version}";

  buildInputs = [ bison libuuid curl libxml2 flex ];

  src = fetchurl {
    url = "http://www.opendap.org/pub/source/${name}.tar.gz";
    sha256 = "0azjf4gjqvp1fdf1wb3s98x52zfy4viq1m3j9lggaidldfinmv8c";
  };

  meta = with stdenv.lib; {
    description = "A C++ SDK which contains an implementation of DAP";
    homepage = http://www.opendap.org/download/libdap;
    license = licenses.lgpl2;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.linux;
  };
}
