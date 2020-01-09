{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "apr-1.7.0";

  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    sha256 = "1spp6r2a3xcl5yajm9safhzyilsdzgagc2dadif8x6z9nbq4iqg2";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./is-this-a-compiler-bug.patch ];

  # This test needs the net
  postPatch = ''
    rm test/testsock.*
  '';

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  preConfigure =
    ''
      configureFlagsArray+=("--with-installbuilddir=$dev/share/build")
    '';

  configureFlags = stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_file__dev_zero=yes"
    "ac_cv_func_setpgrp_void=0"
    "apr_cv_process_shared_works=1"
    "apr_cv_tcp_nodelay_with_cork=1"
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform.system == "i686-cygwin") [
    # Including the Windows headers breaks unistd.h.
    # Based on ftp://sourceware.org/pub/cygwin/release/libapr1/libapr1-1.3.8-2-src.tar.bz2
    "ac_cv_header_windows_h=no"
  ];

  CPPFLAGS=stdenv.lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) "-DAPR_IOVEC_DEFINED";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://apr.apache.org/;
    description = "The Apache Portable Runtime library";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = [ maintainers.eelco ];
  };
}
