{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, binutilsArm
, kernelHeadersArm
}:

assert langC;

stdenv.mkDerivation {
  name = "gcc-4.0.2-arm";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/gcc/gcc-4.0.2/gcc-core-4.0.2.tar.bz2;
    md5 = "f7781398ada62ba255486673e6274b26";
    #url = ftp://ftp.nluug.nl/pub/gnu/gcc/gcc-4.0.2/gcc-4.0.2.tar.bz2;
    #md5 = "a659b8388cac9db2b13e056e574ceeb0";
  };
  # !!! apply only if noSysDirs is set
  patches = [./no-sys-dirs.patch ./gcc-inhibit.patch];
  inherit noSysDirs langC langCC langF77 profiledCompiler;
  buildInputs = [binutilsArm];
  inherit kernelHeadersArm binutilsArm;
  platform = "arm-linux";
}
