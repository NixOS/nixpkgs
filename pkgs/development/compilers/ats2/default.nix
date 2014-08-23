{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name    = "ats2-${version}";
  version = "0.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-${version}.tgz";
    sha256 = "0i7b9v7xki9j2jjjpydz0gl33af94b4jjmk75b9w20bs003v8vd4";
  };

  buildInputs = [ gmp ];

  meta = {
    description = "Functional programming language with dependent types";
    homepage    = "http://www.ats-lang.org";
    license     = stdenv.lib.licenses.gpl3Plus;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
