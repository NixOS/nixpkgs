{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "swi-prolog-5.6.51";

  src = fetchurl {
    url = "http://gollem.science.uva.nl/cgi-bin/nph-download/SWI-Prolog/pl-5.6.51.tar.gz";
    sha256 = "d43862606284e659ec3acba9cddea53b772f9afb67d12aa36391d26fe1a05ad8";
  };

  meta = {
    homepage = http://www.swi-prolog.org/;
    description = "A Prolog compiler and interpreter";
    license = "LGPL";
  };
}
