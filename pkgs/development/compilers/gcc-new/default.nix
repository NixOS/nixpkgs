{ stdenv, fetchurl
, langC ? true, langCC ? true, langF77 ? false
}:

assert langC;

derivation {
  name = "gcc-3.3.2";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
#    url = ftp://ftp.nluug.nl/mirror/languages/gcc/releases/gcc-3.3.3/gcc-3.3.3.tar.bz2;
#    md5 = "3c6cfd9fcd180481063b4058cf6faff2";
    url = ftp://ftp.nluug.nl/pub/gnu/gcc/gcc-3.3.2/gcc-3.3.2.tar.bz2;
    md5 = "65999f654102f5438ac8562d13a6eced";
  };
  noSysDirs = stdenv.noSysDirs;
  inherit stdenv langC langCC langF77;
}
