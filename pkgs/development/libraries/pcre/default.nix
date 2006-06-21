{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pcre-6.6";
  src = fetchurl {
    url = ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-6.6.tar.bz2;
    md5 = "61067f730c46cf6bdd0f8efe3f4f51b6";
  };
}
