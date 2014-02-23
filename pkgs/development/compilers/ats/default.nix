{ stdenv, fetchurl, gmp }:

let version = "0.2.11"; in stdenv.mkDerivation {
  name = "ats-anairiats-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/ats-lang/ats-lang-anairiats-${version}.tgz";
    sha256 = "0rqykyx5whichx85jr4l4c9fdan0qsdd4kwd7a81k3l07zbd9fc6";
  };

  buildInputs = [ gmp ];

  meta = {
    description = "A statically typed programming language that unifies implementation with formal specification";
    homepage = http://www.ats-lang.org/;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
