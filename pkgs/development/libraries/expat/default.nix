{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "expat-2.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/expat/${name}.tar.bz2";
    sha256 = "1zq4lnwjlw8s9mmachwfvfjf2x3lk24jm41746ykhdcvs7r0zrfr";
  };

  configureFlags = stdenv.lib.optional stdenv.isFreeBSD "--with-pic";


  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.libexpat.org/;
    description = "A stream-oriented XML parser library written in C";
    platforms = platforms.all;
    license = licenses.mit; # expat version
  };
}
