{ stdenv, fetchurl, patch, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
}:

assert langC;

stdenv.mkDerivation {
  name = "gcc-3.4.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/mirror/languages/gcc/releases/gcc-3.4.2/gcc-3.4.2.tar.bz2;
    md5 = "2fada3a3effd2fd791df09df1f1534b3";
  };
  # !!! apply only if noSysDirs is set
  patches = [./no-sys-dirs.patch];
  buildInputs = [patch];
  inherit noSysDirs langC langCC langF77 profiledCompiler;
}
