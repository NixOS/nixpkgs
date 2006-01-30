{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libgpg-error-1.0";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libgpg-error-1.0.tar.gz;
    md5 = "ff409db977e4a4897aa09ea420a28a2f";
  };
}
