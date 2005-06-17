{stdenv, fetchurl, kernelHeaders, installLocales ? true}:

stdenv.mkDerivation {
  name = "glibc-2.3.5";
  builder = ./builder.sh;
  substitute = ../../../build-support/substitute/substitute.sh;

  src = fetchurl {
    url = http://ftp.gnu.org/gnu/glibc/glibc-2.3.5.tar.bz2;
    md5 = "93d9c51850e0513aa4846ac0ddcef639";
  };

  linuxthreadsSrc = fetchurl {
    url = http://ftp.gnu.org/gnu/glibc/glibc-linuxthreads-2.3.5.tar.bz2;
    md5 = "77011b0898393c56b799bc011a0f37bf";
  };

  patches = [ ./glibc-pwd.patch ];

  inherit kernelHeaders installLocales;
}
