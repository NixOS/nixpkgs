{ stdenv, fetchurl, gmp }:

let version = "0.0.6"; in stdenv.mkDerivation {
  name = "ats2-postiats-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-${version}.tgz";
    sha256 = "110a4drzf656j9s5yfvxj1cwgh5g9ysnh40cv8y9qfjjkki8vd5b";
  };

  buildInputs = [ gmp ];

  meta = {
    description = "A statically typed programming language that unifies implementation with formal specification";
    homepage = http://www.ats-lang.org/;
    license = stdenv.lib.licenses.gpl3Plus;
  };

  platforms = stdenv.lib.platforms.all;
}
