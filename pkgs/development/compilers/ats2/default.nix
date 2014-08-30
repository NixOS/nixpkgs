{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name    = "ats2-${version}";
  version = "0.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-${version}.tgz";
    sha256 = "17yr5zc4cr4zlizhzy43ihfcidl63wjxcc002amzahskib4fsbmb";
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
