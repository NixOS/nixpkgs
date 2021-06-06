{ stdenv, lib, fetchurl, perl, gfortran
, openssh, hwloc
# either libfabric or ucx work for ch4backend on linux. On darwin, neither of
# these libraries currently build so this argument is ignored on Darwin.
, ch4backend
# Process manager to build
, withPm ? "hydra:gforker"
} :

assert (ch4backend.pname == "ucx" || ch4backend.pname == "libfabric");

stdenv.mkDerivation  rec {
  pname = "mpich";
  version = "3.4.2";

  src = fetchurl {
    url = "https://www.mpich.org/static/downloads/${version}/mpich-${version}.tar.gz";
    sha256 = "1gw7qpb27mhsj7ip0hhljshgpwvz2hmyhizhlp6793afp2lbw6aw";
  };

  configureFlags = [
    "--enable-shared"
    "--enable-sharedlib"
    "--with-pm=${withPm}"
  ];

  enableParallelBuilding = true;

  buildInputs = [ perl gfortran openssh hwloc ]
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
