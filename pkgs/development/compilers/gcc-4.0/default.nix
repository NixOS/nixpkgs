{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
}:

assert langC;

stdenv.mkDerivation {
  name = "gcc-4.0.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gcc-4.0.2.tar.bz2;
    md5 = "a659b8388cac9db2b13e056e574ceeb0";
  };
  # !!! apply only if noSysDirs is set
  patches = [./no-sys-dirs.patch];
  inherit noSysDirs langC langCC langF77 profiledCompiler;
}
