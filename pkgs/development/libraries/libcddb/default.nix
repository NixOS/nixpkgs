{fetchurl, stdenv}:

stdenv.mkDerivation rec {
  name = "libcddb-1.3.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/libcddb/${name}.tar.bz2";
    sha256 = "0fr21a7vprdyy1bq6s99m0x420c9jm5fipsd63pqv8qyfkhhxkim";
  };

  meta = {
    description = "Libcddb is a C library to access data on a CDDB server (freedb.org)";
    license = stdenv.lib.licenses.lgpl2Plus;
    homepage = http://libcddb.sourceforge.net/;
  };
}
