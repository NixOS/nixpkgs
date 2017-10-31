{ stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  name = "libcddb-1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/libcddb/${name}.tar.bz2";
    sha256 = "0fr21a7vprdyy1bq6s99m0x420c9jm5fipsd63pqv8qyfkhhxkim";
  };

  buildInputs = stdenv.lib.optional stdenv.isDarwin libiconv;

  meta = with stdenv.lib; {
    description = "C library to access data on a CDDB server (freedb.org)";
    homepage = http://libcddb.sourceforge.net/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
