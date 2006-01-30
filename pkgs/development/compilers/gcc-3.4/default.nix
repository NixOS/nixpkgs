{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
}:

assert langC;

stdenv.mkDerivation {
  name = "gcc-3.4.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gcc-3.4.5.tar.bz2;
    md5 = "7c3c3c3e764dcee5eb771432062d69e1";
  };
  # !!! apply only if noSysDirs is set
  patches = [./no-sys-dirs.patch];
  inherit noSysDirs langC langCC langF77 profiledCompiler;
}
