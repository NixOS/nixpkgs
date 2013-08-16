{ stdenv, fetchurl }:

let
   inherit (stdenv.lib) optionals;
in

stdenv.mkDerivation rec {
  name = "apr-1.4.8";

  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    md5 = "ce2ab01a0c3cdb71cf0a6326b8654f41";
  };

  patches = optionals stdenv.isDarwin [ ./darwin_fix_configure.patch ];

  configureFlags =
    # Including the Windows headers breaks unistd.h.
    # Based on ftp://sourceware.org/pub/cygwin/release/libapr1/libapr1-1.3.8-2-src.tar.bz2
    stdenv.lib.optional (stdenv.system == "i686-cygwin") "ac_cv_header_windows_h=no";

  meta = {
    homepage = http://apr.apache.org/;
    description = "The Apache Portable Runtime library";
  };
}
