{ stdenv, fetchurl, patch, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
}:

assert langC;

stdenv.mkDerivation {
  name = "gcc-3.4.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/mirror/languages/gcc/releases/gcc-3.4.1/gcc-3.4.1.tar.bz2;
    md5 = "31b459062499f9f68d451db9cbf3205c";
  };
  # !!! apply only if noSysDirs is set
  patches = [./no-sys-dirs.patch];
  buildInputs = [patch];
  inherit noSysDirs langC langCC langF77 profiledCompiler;
}
