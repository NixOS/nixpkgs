{stdenv, fetchurl, j2sdk}:

stdenv.mkDerivation {
  name = "shared-objects-1.4";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/shared-objects-1.4.tar.gz;
    md5 = "c1f2c58bd1a07be32da8a6b89354a11f";
  };
  buildInputs = [stdenv j2sdk];
}
