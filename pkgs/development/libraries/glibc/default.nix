{stdenv, fetchurl, kernelHeaders, installLocales ? true}:

stdenv.mkDerivation {
  name = "glibc-2.3.3";
  builder = ./builder.sh;
  substitute = ../../../build-support/substitute/substitute.sh;

  src = fetchurl {
    url = ftp://sources.redhat.com/pub/glibc/snapshots/glibc-20050110.tar.bz2;
    md5 = "1171587e4802f43fdda315910adc1854";
  };

  patches = [ ./glibc-pwd.patch ];

  inherit kernelHeaders installLocales;
}
