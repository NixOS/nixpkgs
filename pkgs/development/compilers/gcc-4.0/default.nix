{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
}:

assert langC;

stdenv.mkDerivation {
  name = "gcc-4.0.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/mirror/languages/gcc/releases/gcc-4.0.0/gcc-4.0.0.tar.bz2;
    md5 = "55ee7df1b29f719138ec063c57b89db6";
  };
  # !!! apply only if noSysDirs is set
  patches = [./no-sys-dirs.patch];
  inherit noSysDirs langC langCC langF77 profiledCompiler;
}
