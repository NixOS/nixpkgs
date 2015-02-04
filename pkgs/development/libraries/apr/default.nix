{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "apr-1.5.1";

  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    sha256 = "1b4qw686bwjn19iyb0lg918q23xxd6s2gnyczhjq992d3m1vwjp9";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./is-this-a-compiler-bug.patch ];

  configureFlags =
    # Including the Windows headers breaks unistd.h.
    # Based on ftp://sourceware.org/pub/cygwin/release/libapr1/libapr1-1.3.8-2-src.tar.bz2
    stdenv.lib.optional (stdenv.system == "i686-cygwin") "ac_cv_header_windows_h=no";

  enableParallelBuilding = true;

  meta = {
    homepage = http://apr.apache.org/;
    description = "The Apache Portable Runtime library";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
