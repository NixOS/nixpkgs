{ stdenv, fetchurl, gmp }:

let version = "0.0.3"; in stdenv.mkDerivation {
  name = "ats2-postiats-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-${version}.tgz";
    sha256 = "0hq63zrmm92j5ffnsmylhhllm8kgjpjkaj4xvzz1zlshz39lijxp";
  };

  buildInputs = [ gmp ];

  meta = {
    description = "A statically typed programming language that unifies implementation with formal specification";
    homepage = http://www.ats-lang.org/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
