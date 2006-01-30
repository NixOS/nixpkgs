{stdenv, fetchurl, zlib, libjpeg}:

assert zlib != null && libjpeg != null;

stdenv.mkDerivation {
  name = "libtiff-3.7.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/tiff-3.7.4.tar.gz;
    md5 = "f37a7907bca4e235da85eb0126caa2b0";
  };
  propagatedBuildInputs = [zlib libjpeg];
  inherit zlib libjpeg;
}
