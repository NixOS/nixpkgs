{stdenv, fetchurl, kernelHeaders, installLocales ? true}:

stdenv.mkDerivation {
  name = "glibc-2.3.4";
  builder = ./builder.sh;
  substitute = ../../../build-support/substitute/substitute.sh;

  src = fetchurl {
    url = http://ftp.gnu.org/gnu/glibc/glibc-2.3.4.tar.bz2;
    md5 = "174ac5ed4f2851fcc866a3bac1e4a6a5";
  };

  linuxthreadsSrc = fetchurl {
    url = http://ftp.gnu.org/gnu/glibc/glibc-linuxthreads-2.3.4.tar.bz2;
    md5 = "7a199cd4965eb5622163756ae64358fe";
  };

  patches = [ ./glibc-pwd.patch ];

  inherit kernelHeaders installLocales;
}
