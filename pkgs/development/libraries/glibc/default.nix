{ stdenv, fetchurl, kernelHeaders
, installLocales ? true
, profilingLibraries ? false
}:

stdenv.mkDerivation {
  name = "glibc-2.5";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://ftp.gnu.org/gnu/glibc/glibc-2.5.tar.bz2;
    md5 = "1fb29764a6a650a4d5b409dda227ac9f";
  };

  linuxthreadsSrc = fetchurl {
    url = http://ftp.gnu.org/gnu/glibc/glibc-linuxthreads-2.5.tar.bz2;
    md5 = "870d76d46dcaba37c13d01dca47d1774";
  };

  patches = [ ./glibc-pwd.patch ./glibc-getcwd-param-MAX.patch ];

  inherit kernelHeaders installLocales;

  inherit (stdenv) is64bit;

  # `--with-tls --without-__thread' enables support for TLS but causes
  # it not to be used.  Required if we don't want to barf on 2.4
  # kernels.  Or something.
  configureFlags="--enable-add-ons
    --with-headers=${kernelHeaders}/include
    --with-tls --without-__thread --disable-sanity-checks
    ${if profilingLibraries then "--enable-profile" else "--disable-profile"}";
}
