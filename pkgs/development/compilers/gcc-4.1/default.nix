{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
}:

assert langC;

stdenv.mkDerivation {
  name = "gcc-4.1.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/gcc/gcc-4.1.0/gcc-4.1.0.tar.bz2;
    md5 = "88785071f29ed0e0b6b61057a1079442";
  };
  # !!! apply only if noSysDirs is set
  patches = [./no-sys-dirs.patch];
  #patches = [./no-sys-dirs.patch ./gcc-4.0.2-cxx.patch];
  inherit noSysDirs langC langCC langF77 profiledCompiler;
}
