{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pcre-6.0";
  src = fetchurl {
    url = ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-6.0.tar.bz2;
    md5 = "9352eb6d2be5ad9d8360d2377d3cafac";
  };
}
