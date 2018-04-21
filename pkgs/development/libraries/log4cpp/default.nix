{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "log4cpp-1.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/log4cpp/${name}.tar.gz";
    sha256 = "07gmr3jyaf2239n9sp6h7hwdz1pv7b7aka8n06gmr2fnlmaymfrc";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage    = "http://log4cpp.sourceforge.net/";
    description = "A logging framework for C++ patterned after Apache log4j";
    license     = licenses.lgpl21Plus;
    platforms   = platforms.unix;
  };
}
