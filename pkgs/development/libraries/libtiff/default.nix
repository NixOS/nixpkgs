{stdenv, fetchurl, zlib, libjpeg}:

assert zlib != null && libjpeg != null;

stdenv.mkDerivation {
  name = "libtiff-3.7.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/tiff-3.7.2.tar.gz;
    md5 = "9d7123bd0dbde2a3853fb758346adb78";
  };
  propagatedBuildInputs = [zlib libjpeg];
  inherit zlib libjpeg;
}
