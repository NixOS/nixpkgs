{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pcre-6.7";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pcre-6.7.tar.bz2;
    md5 = "dbbec9d178ce199e67e98c9a4f994f90";
  };
}
