{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "log4cpp-1.1.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/log4cpp/${name}.tar.gz";
    sha256 = "1l5yz5rfzzv6g3ynrj14mxfsk08cp5h1ssr7d74hjs0accrg7arm";
  };

  meta = {
    homepage = http://log4cpp.sourceforge.net/;
    description = "A logging framework for C++ patterned after Apache log4j";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
