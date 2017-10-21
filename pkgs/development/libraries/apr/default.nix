{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "apr-1.6.2";

  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    sha256 = "1gffipa87pflvgvw01dbkvgh75p8n2sr56m1pcl01avv6zm9q409";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./is-this-a-compiler-bug.patch ];

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  preConfigure =
    ''
      configureFlagsArray+=("--with-installbuilddir=$dev/share/build")
    '';

  configureFlags =
    # Including the Windows headers breaks unistd.h.
    # Based on ftp://sourceware.org/pub/cygwin/release/libapr1/libapr1-1.3.8-2-src.tar.bz2
    stdenv.lib.optional (stdenv.system == "i686-cygwin") "ac_cv_header_windows_h=no";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://apr.apache.org/;
    description = "The Apache Portable Runtime library";
    platforms = platforms.all;
    maintainers = [ maintainers.eelco ];
  };
}
