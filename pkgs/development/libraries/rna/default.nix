{stdenv, fetchurl, zlib}:

assert zlib != null;

derivation {
  name = "rna-0.14c";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.radionetworkprocessor.com/pub/radionetworkprocessor/rna-0.14c.tar.gz;
    md5 = "1e2947caf8a680e93cac55bffe2d6ec6";
  };
  inherit stdenv zlib;
}
