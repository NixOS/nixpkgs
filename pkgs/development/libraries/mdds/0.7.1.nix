{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.7.1";
  name = "mdds-${version}";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/multidimalgorithm/mdds_${version}.tar.bz2";
    sha256 = "0zhrx7m04pknc8i2cialmbna1hmwa0fzs8qphan4rdxibf0c4yzy";
  };

  meta = {
    homepage = https://gitlab.com/mdds/mdds/;
    description = "A collection of multi-dimensional data structure and indexing algorithm";
    platforms = stdenv.lib.platforms.all;
  };
}
