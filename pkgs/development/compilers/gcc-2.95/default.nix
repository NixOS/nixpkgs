{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
}:

assert langC;

stdenv.mkDerivation {
  name = "gcc-2.95.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://gnu/gcc/gcc-2.95.3.tar.gz;
    md5 = "f3ad4f32c2296fad758ed051b5ac8e28";
  };
  # !!! apply only if noSysDirs is set
  patches = [./no-sys-dirs.patch];
  inherit noSysDirs langC langCC langF77;
}
