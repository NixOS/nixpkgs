{ stdenv, lib, fetchurl, perl, gfortran
, openssh, hwloc, python3
# either libfabric or ucx work for ch4backend on linux. On darwin, neither of
# these libraries currently build so this argument is ignored on Darwin.
, ch4backend
# Process manager to build
, withPm ? "hydra:gforker"
} :

assert (ch4backend.pname == "ucx" || ch4backend.pname == "libfabric");

stdenv.mkDerivation  rec {
  pname = "mpich";
  version = "4.0.1";

  src = fetchurl {
    url = "https://www.mpich.org/static/downloads/${version}/mpich-${version}.tar.gz";
    sha256 = "11rnljqwz6mr88ybj726mk710h7gvz20hy7labmz4jkkaa0gx8b6";
  };

  configureFlags = [
    "--enable-shared"
    "--enable-sharedlib"
    "--with-pm=${withPm}"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ gfortran python3 ];
  buildInputs = [ perl openssh hwloc ]
    ++ lib.optional (!stdenv.isDarwin) ch4backend;

  doCheck = true;

  preFixup = ''
    # Ensure the default compilers are the ones mpich was built with
    sed -i 's:CC="gcc":CC=${stdenv.cc}/bin/gcc:' $out/bin/mpicc
    sed -i 's:CXX="g++":CXX=${stdenv.cc}/bin/g++:' $out/bin/mpicxx
    sed -i 's:FC="gfortran":FC=${gfortran}/bin/gfortran:' $out/bin/mpifort
  '';

  meta = with lib; {
    description = "Implementation of the Message Passing Interface (MPI) standard";

    longDescription = ''
      MPICH2 is a free high-performance and portable implementation of
      the Message Passing Interface (MPI) standard, both version 1 and
      version 2.
    '';
    homepage = "http://www.mcs.anl.gov/mpi/mpich2/";
    license = {
      url = "http://git.mpich.org/mpich.git/blob/a385d6d0d55e83c3709ae851967ce613e892cd21:/COPYRIGHT";
      fullName = "MPICH license (permissive)";
    };
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
