{ stdenv, fetchurl, gmp }:

let version = "0.2.11"; in stdenv.mkDerivation {
  name = "ats2-postiats-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/ats-lang/ats-lang-anairiats-${version}.tgz";
    sha256 = "1rzcqc7fwqf0y4cc14lr282r25s66jygf6cxrnf5l8p5p550l0dl";
  };

  buildInputs = [ gmp ];

  meta = {
    description = "A statically typed programming language that unifies implementation with formal specification";
    homepage = http://www.ats-lang.org/;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
