{ stdenv, fetchurl, patch, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
}:

assert langC;

stdenv.mkDerivation {
  name = "gcc-3.4.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/mirror/languages/gcc/releases/gcc-3.4.0/gcc-3.4.0.tar.bz2;
    md5 = "85c6fc83d51be0fbb4f8205accbaff59";
  };
  # !!! apply only if noSysDirs is set
  patches = [./no-sys-dirs.patch];
  buildInputs = [patch];
  inherit noSysDirs langC langCC langF77;
}
