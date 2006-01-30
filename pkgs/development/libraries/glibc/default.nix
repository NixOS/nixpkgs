{stdenv, fetchurl, kernelHeaders, installLocales ? true}:

stdenv.mkDerivation {
  name = "glibc-2.3.6";
  builder = ./builder.sh;
  substitute = ../../../build-support/substitute/substitute.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/glibc-2.3.6.tar.bz2;
    md5 = "bfdce99f82d6dbcb64b7f11c05d6bc96";
  };

  linuxthreadsSrc = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/glibc-linuxthreads-2.3.6.tar.bz2;
    md5 = "d4eeda37472666a15cc1f407e9c987a9";
  };

  patches = [ ./glibc-pwd.patch ];

  inherit kernelHeaders installLocales;
}
