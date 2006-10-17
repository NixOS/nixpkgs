{stdenv, fetchurl, kernelHeaders, installLocales ? true}:

stdenv.mkDerivation {
  name = "glibc-2.5";
  builder = ./builder.sh;
  substitute = ../../../build-support/substitute/substitute.sh;

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
}
