{ stdenv, fetchurl
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, glibc
}:

assert langC;

stdenv.mkDerivation {
  name = "gcc-4.1.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gcc-4.1.1.tar.bz2;
    md5 = "ad9f97a4d04982ccf4fd67cb464879f3";
  };
  patches = [./pass-cxxcpp.patch ./no-sys-dirs.patch];
  inherit langC langCC langF77 profiledCompiler glibc;
  noSysDirs = 1;
}
