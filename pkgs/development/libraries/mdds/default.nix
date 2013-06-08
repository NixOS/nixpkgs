{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mdds-0.6.0";

  src = fetchurl {
    url = http://multidimalgorithm.googlecode.com/files/mdds_0.6.0.tar.bz2;
    sha256 = "0yx6cx2cxk9wpmfpv6k3agkr1sjzxdgxrm3zfj34zwyxr3sh0ql4";
  };

  meta = {
    homepage = https://code.google.com/p/multidimalgorithm/;
    description = "A collection of multi-dimensional data structure and indexing algorithm";
    platforms = stdenv.lib.platforms.all;
  };
}
