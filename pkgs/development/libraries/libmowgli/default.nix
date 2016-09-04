{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libmowgli-0.9.50";
  
  src = fetchurl {
    url = "http://distfiles.atheme.org/${name}.tar.bz2";
    sha256 = "0wbnpd2rzk5jg6pghgxyx7brjrdmsyg4p0mm9blwmrdrj5ybxx9z";
  };
  
  meta = {
    description = "A development framework for C providing high performance and highly flexible algorithms";
    homepage = http://www.atheme.org/projects/mowgli.shtml;
    platforms = stdenv.lib.platforms.unix;
  };
}
