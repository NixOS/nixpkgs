{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "apr-1.5.0";

  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    md5 = "cc93bd2c12d0d037f68e21cc6385dc31";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./darwin_fix_configure.patch ];

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
