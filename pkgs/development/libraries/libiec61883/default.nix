{ stdenv, fetchurl, pkgconfig, libraw1394 }:

stdenv.mkDerivation rec {
  version = "1.2.0";
  name = "libiec61883-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/libi/libiec61883/libiec61883_${version}.orig.tar.gz";
    name = "libiec61883-${version}.tar.gz";
    sha256 = "7c7879c6b9add3148baea697dfbfdcefffbc8ac74e8e6bcf46125ec1d21b373a";
  };

  buildInputs = [ pkgconfig ];
  
  propagatedBuildInputs = [ libraw1394 ];

  meta = { 
    homepage = http://www.linux1394.org;
    license = "LGPL";
  };
}
