{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
}:

assert langC;

stdenv.mkDerivation {
  name = "gcc-3.3.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/gcc-3.3.3.tar.bz2;
    md5 = "3c6cfd9fcd180481063b4058cf6faff2";
  };
  inherit noSysDirs langC langCC langF77;
}
