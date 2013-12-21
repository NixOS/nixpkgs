{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.8.1";
  name = "mdds-${version}";

  src = fetchurl {
    url = "http://multidimalgorithm.googlecode.com/files/mdds_${version}.tar.bz2";
    sha256 = "12w8rs8kb8yffndsw0g7qfjvy4gpnppkdzc7r7vvc9n800ixl1gn";
  };

  meta = {
    homepage = https://code.google.com/p/multidimalgorithm/;
    description = "A collection of multi-dimensional data structure and indexing algorithm";
    platforms = stdenv.lib.platforms.all;
  };
}
