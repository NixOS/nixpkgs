{ stdenv, fetchFromGitHub, cmake, openssh
, gfortran, mpi, blas, lapack
} :

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "scalapack";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Reference-ScaLAPACK";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c10d18gj3kvpmyv5q246x35hjxaqn4ygy1cygaydhyxnm4klzdj";
  };

  nativeBuildInputs = [ cmake openssh ];
  buildInputs = [ mpi gfortran blas lapack ];

  enableParallelBuilding = true;

  doCheck = true;

  preConfigure = ''
    cmakeFlagsArray+=(
      -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF
      -DLAPACK_LIBRARIES="-llapack"
      -DBLAS_LIBRARIES="-lblas"
      )
  '';

  # Increase individual test timeout from 1500s to 10000s because hydra's builds
  # sometimes fail due to this
  checkFlagsArray = [ "ARGS=--timeout 10000" ];

  preCheck = ''
    # make sure the test starts even if we have less than 4 cores
    export OMPI_MCA_rmaps_base_oversubscribe=1

    # Run single threaded
    export OMP_NUM_THREADS=1

    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}`pwd`/lib
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.netlib.org/scalapack/";
    description = "Library of high-performance linear algebra routines for parallel distributed memory machines";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ costrouc markuskowa ];
  };

}
