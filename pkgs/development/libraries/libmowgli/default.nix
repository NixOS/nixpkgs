{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libmowgli-${version}";
  version = "2.1.3";
  
  src = fetchurl {
    url = "https://github.com/atheme/libmowgli-2/archive/v${version}.tar.gz";
    sha256 = "0xx4vndmwz40pxa5gikl8z8cskpdl9a30i2i5fjncqzlp4pspymp";
  };
  
  meta = {
    description = "A development framework for C providing high performance and highly flexible algorithms";
    homepage = http://www.atheme.org/projects/mowgli.shtml;
    platforms = stdenv.lib.platforms.unix;
  };
}
