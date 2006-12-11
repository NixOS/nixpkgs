{stdenv, fetchurl}:
   
stdenv.mkDerivation {
  name = "libxcrypt-2.4";
   
  src = fetchurl {
    url = ftp://ftp.suse.com/pub/people/kukuk/libxcrypt/libxcrypt-2.4.tar.bz2;
    md5 = "b5ae266550af2d04423da7d3af08a82a";
  };
}
