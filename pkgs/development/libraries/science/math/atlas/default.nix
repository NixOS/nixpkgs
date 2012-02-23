{ stdenv, fetchurl, gfortran, tolerateCpuTimingInaccuracy ? true }:

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

  # * The manual says you should pass -fPIC as configure arg. Not sure why, but
  #   it works.
  #
  # * Atlas aborts the build if it detects that some kind of CPU frequency
  #   scaling is active on the build machine because that feature offsets the
  #   performance timings. We ignore that check, however, because with binaries
  #   being pre-built on Hydra those timings aren't accurate for the local
  #   machine in the first place.
  configureFlags = "-Fa alg -fPIC"
    + optionalString stdenv.isi686 " -b 32"
    + optionalString tolerateCpuTimingInaccuracy " -Si cputhrchk 0";

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
