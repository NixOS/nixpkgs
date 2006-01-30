{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pcre-6.4";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pcre-6.4.tar.bz2;
    md5 = "c5c73e8767479e8a7751324b0aa32291";
  };
}
