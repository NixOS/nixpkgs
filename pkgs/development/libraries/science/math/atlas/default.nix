{ stdenv, fetchurl, gfortran, tolerateCpuTimingInaccuracy ? true, shared ? false
, cpuConfig ? if stdenv.isi686 then "-b 32 -A 18 -V 1" else "-b 64 -A 31 -V 192"
}:

# Atlas detects the CPU and optimizes its build accordingly. This is great when
# the code is run on the same machine that built the binary, but in case of a
# central build farm like Hydra, this feature is dangerous because the code may
# be generated utilizing fancy features that users who download the binary
# cannot execute.
#
# To avoid these issues, the build is configured using the 'cpuConfig'
# parameter as follows:
#
#   | x86 CPU                                     | x86_64 CPU             |
#   |---------------------------------------------+------------------------|
#   | -b 32                                       | -b 64                  |
#   | -A 18  (Pentium II)                         | -A 31 (Athlon K7)      |
#   | -V 1 (No SIMD: Pentium II doesn't have SSE) | -V 192 (SSE1 and SSE2) |
#
# Users who want to compile a highly optimized version of ATLAS that's suitable
# for their local machine can override these settings accordingly.

let
  version = "3.10.1";

  optionalString = stdenv.lib.optionalString;
  optional = stdenv.lib.optional;
in

stdenv.mkDerivation {
  name = "atlas-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/math-atlas/atlas${version}.tar.bz2";
    sha256 = "11ncgdc7kzb2y2gqb3sgarm5saj9fr07r3h2yh2h5bja429b85d2";
  };

  buildInputs = [ gfortran ];

  # Atlas aborts the build if it detects that some kind of CPU frequency
  # scaling is active on the build machine because that feature offsets the
  # performance timings. We ignore that check, however, because with binaries
  # being pre-built on Hydra those timings aren't accurate for the local
  # machine in the first place.
  patches = optional tolerateCpuTimingInaccuracy ./disable-timing-accuracy-check.patch;

  # Configure outside of the source directory.
  preConfigure = '' mkdir build; cd build; configureScript=../configure; '';

  # * -fPIC is passed even in non-shared builds so that the ATLAS code can be
  #   used to inside of shared libraries, like Octave does.
  #
  # * -t 0 disables use of multi-threading. It's not quite clear what the
  #   consequences of that setting are and whether it's necessary or not.
  configureFlags = "-Fa alg -fPIC -t 0 ${cpuConfig}" + optionalString shared " --shared";

  doCheck = true;

  meta = {
    homepage = "http://math-atlas.sourceforge.net/";
    description = "Automatically Tuned Linear Algebra Software (ATLAS)";
    license = stdenv.lib.licenses.bsd3;

    longDescription = ''
      The ATLAS (Automatically Tuned Linear Algebra Software) project is an ongoing
      research effort focusing on applying empirical techniques in order to provide
      portable performance. At present, it provides C and Fortran77 interfaces to a
      portably efficient BLAS implementation, as well as a few routines from LAPACK.
    '';
  };
}
