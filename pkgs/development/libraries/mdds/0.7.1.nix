{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.7.1";
  name = "mdds-${version}";

  src = fetchurl {
    url = "http://multidimalgorithm.googlecode.com/files/mdds_${version}.tar.bz2";
    sha256 = "0zhrx7m04pknc8i2cialmbna1hmwa0fzs8qphan4rdxibf0c4yzy";
  };

  meta = {
    homepage = https://code.google.com/p/multidimalgorithm/;
    description = "A collection of multi-dimensional data structure and indexing algorithm";
    platforms = stdenv.lib.platforms.all;
  };
}
