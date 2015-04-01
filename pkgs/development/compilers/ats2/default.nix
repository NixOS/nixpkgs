{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name    = "ats2-${version}";
  version = "0.1.9";

  src = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-${version}.tgz";
    sha256 = "0zcki97zj9r1dvlfriwfckp9b9z7iavw09q21v6i5ld90hw9588q";
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
