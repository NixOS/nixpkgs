{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, binutilsArm
}:

assert langC;

stdenv.mkDerivation {
  name = "gcc-3.4.4-arm";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/gcc/gcc-3.4.4/gcc-3.4.4.tar.bz2;
    md5 = "b594ff4ea4fbef4ba9220887de713dfe";
  };
  # !!! apply only if noSysDirs is set
  patches = [./no-sys-dirs.patch];
  inherit noSysDirs langC langCC langF77 profiledCompiler;
  buildInputs = [binutilsArm];
  platform = "arm-linux";
}
