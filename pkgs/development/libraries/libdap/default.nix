{ stdenv, fetchurl, bison, libuuid, curl, libxml2, flex }:

stdenv.mkDerivation rec {
  version = "3.20.3";
  name = "libdap-${version}";

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libuuid curl libxml2 ];

  src = fetchurl {
    url = "https://www.opendap.org/pub/source/${name}.tar.gz";
    sha256 = "0n6ciicaa7sn88gvg5sgcq0438i3vh6xbl9lxgafjqiznli1k5i9";
  };

  meta = with stdenv.lib; {
    description = "A C++ SDK which contains an implementation of DAP";
    homepage = https://www.opendap.org/software/libdap;
    license = licenses.lgpl2;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.linux;
  };
}
