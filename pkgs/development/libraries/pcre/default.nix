{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pcre-4.3";
  src = fetchurl {
    url = ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-4.3.tar.bz2;
    md5 = "7bc7d5b590a41e6f9ede30f272002a02";
  };
}
