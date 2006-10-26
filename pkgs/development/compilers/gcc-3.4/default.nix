{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
}:

assert langC;

stdenv.mkDerivation {
  name = "gcc-3.4.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gcc-3.4.6.tar.bz2;
    md5 = "4a21ac777d4b5617283ce488b808da7b";
  };

  patches = if noSysDirs then [./no-sys-dirs.patch] else [];

  inherit noSysDirs langC langCC langF77 profiledCompiler;

  meta = {
    homepage = "http://gcc.gnu.org/";
    license = "GPL/LGPL";
    description = "GNU Compiler Collection, 3.4.x";
  };
}
