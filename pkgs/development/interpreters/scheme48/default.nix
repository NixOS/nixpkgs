{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "scheme48-1.9.2";

  meta = {
    homepage = "http://s48.org/";
    description = "Scheme 48";
    platforms = with stdenv.lib.platforms; unix;
    license = stdenv.lib.licenses.bsd3;
  };

  src = fetchurl {
    url = "http://s48.org/1.9.2/scheme48-1.9.2.tgz";
    sha256 = "1x4xfm3lyz2piqcw1h01vbs1iq89zq7wrsfjgh3fxnlm1slj2jcw";
  };
}
