{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name    = "ats2-${version}";
  version = "0.1.10";

  src = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-${version}.tgz";
    sha256 = "0hxjgpyc0m44w58aqzglbgraqirijs3497q9s6ymam4fnj0i57s2";
  };

  buildInputs = [ gmp ];

  meta = {
    description = "Functional programming language with dependent types";
    homepage    = "http://www.ats-lang.org";
    license     = stdenv.lib.licenses.gpl3Plus;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
