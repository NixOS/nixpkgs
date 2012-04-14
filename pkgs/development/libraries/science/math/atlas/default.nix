{ stdenv, fetchurl, gfortran, tolerateCpuTimingInaccuracy ? true, shared ? false }:

let
  optionalString = stdenv.lib.optionalString;
in

stdenv.mkDerivation {
  name = "atlas-3.9.67";

  src = fetchurl {
    url = mirror://sf/math-atlas/atlas3.9.67.tar.bz2;
    sha256 = "06xxlv440z8a3qmfrh17p28girv71c6awvpw5vhpspr0pcsgk1pa";
  };

  # Configure outside of the source directory.
  preConfigure = '' mkdir build; cd build; configureScript=../configure; '';

  # * -fPIC allows to build atlas inside shared objects, as octave does.
  #
  # * Atlas aborts the build if it detects that some kind of CPU frequency
  #   scaling is active on the build machine because that feature offsets the
  #   performance timings. We ignore that check, however, because with binaries
  #   being pre-built on Hydra those timings aren't accurate for the local
  #   machine in the first place.
  # * Atlas detects the cpu and does some tricks. For example, notices the
  #   hydra AMD Family 10h computer, and uses a SSE trick for it (bit 17 of MXCSR)
  #   available, for what I know, only in that family. So we hardcode K7
  #     -A 31 = Athlon K7
  #     -A 18 = Pentium II
  #     -V 192 = SSE1|SSE2 (Or it takes SSE3 somehow in my machine without SSE3)
  #     -V 0 = No SIMD (Pentium II does not have any SSE)
  #     -t 0 = No threading
  configureFlags = "-t 0"
    + optionalString stdenv.isi686 " -b 32 -A 18 -V 0"
    + optionalString stdenv.isx86_64 " -A 31 -V 192"
    + optionalString tolerateCpuTimingInaccuracy " -Si cputhrchk 0"
    + optionalString shared " --shared "
    ;

  buildInputs = [ gfortran ];

  doCheck = true;

  meta = {
    homepage = "http://math-atlas.sourceforge.net/";
    description = "Automatically Tuned Linear Algebra Software (ATLAS)";
    license = "GPL";

    longDescription = ''
      The ATLAS (Automatically Tuned Linear Algebra Software) project is an ongoing
      research effort focusing on applying empirical techniques in order to provide
      portable performance. At present, it provides C and Fortran77 interfaces to a
      portably efficient BLAS implementation, as well as a few routines from LAPACK.
    '';
  };
}
