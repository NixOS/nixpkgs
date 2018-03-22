{ stdenv, fetchurl, bison, libuuid, curl, libxml2, flex }:

stdenv.mkDerivation rec {
  version = "3.19.1";
  name = "libdap-${version}";

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libuuid curl libxml2 ];

  src = fetchurl {
    url = "http://www.opendap.org/pub/source/${name}.tar.gz";
    sha256 = "0gnki93z3kkzp65x7n1kancy7bd503j4qja5fhzvm1gkmi5l65aj";
  };

  meta = with stdenv.lib; {
    description = "A C++ SDK which contains an implementation of DAP";
    homepage = https://www.opendap.org/download/libdap;
    license = licenses.lgpl2;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.linux;
  };
}
