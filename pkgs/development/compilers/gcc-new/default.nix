{ stdenv, fetchurl, noSysDirs ? true
, langC ? true, langCC ? true, langF77 ? false
}:

assert langC;

derivation {
  name = "gcc-3.3.3";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/mirror/languages/gcc/releases/gcc-3.3.3/gcc-3.3.3.tar.bz2;
    md5 = "3c6cfd9fcd180481063b4058cf6faff2";
  };
  inherit stdenv noSysDirs langC langCC langF77;
}
