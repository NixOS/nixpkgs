{args, sha256}: with args;

stdenv.mkDerivation {
  name = "swi-prolog-${version}";

  src = fetchurl {
    url = "http://gollem.science.uva.nl/cgi-bin/nph-download/SWI-Prolog/pl-${version}.tar.gz";
    inherit sha256;
  };

  meta = {
    homepage = http://www.swi-prolog.org/;
    description = "A Prolog compiler and interpreter.";
    license = "LGPL";
  };
}
