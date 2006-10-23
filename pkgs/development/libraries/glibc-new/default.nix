{ stdenv, fetchurl, kernelHeaders
, installLocales ? true
, profilingLibraries ? false
}:

stdenv.mkDerivation {
  name = "glibc-2.5";
  builder = ./builder.sh;
  substitute = ../../../build-support/substitute/substitute.sh;

  /*
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/glibc-2.3.6.tar.bz2;
    md5 = "bfdce99f82d6dbcb64b7f11c05d6bc96";
  };

  linuxthreadsSrc = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/glibc-linuxthreads-2.3.6.tar.bz2;
    md5 = "d4eeda37472666a15cc1f407e9c987a9";
  };
  */

  src = fetchurl {
    url = http://ftp.gnu.org/gnu/glibc/glibc-2.5.tar.bz2;
    md5 = "1fb29764a6a650a4d5b409dda227ac9f";
  };

  linuxthreadsSrc = fetchurl {
    url = http://ftp.gnu.org/gnu/glibc/glibc-linuxthreads-2.5.tar.bz2;
    md5 = "870d76d46dcaba37c13d01dca47d1774";
  };

  patches = [ ./glibc-pwd.patch ];

  inherit kernelHeaders installLocales;

  # `--with-tls --without-__thread' enables support for TLS but causes
  # it not to be used.  Required if we don't want to barf on 2.4
  # kernels.  Or something.
  configureFlags="--enable-add-ons
    --with-headers=${kernelHeaders}/include
    --with-tls --without-__thread --disable-sanity-checks
    ${if profilingLibraries then "--enable-profile" else "--disable-profile"}";
}
