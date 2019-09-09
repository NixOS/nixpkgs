{ stdenv, fetchurl, cmake, openssh
, gfortran, mpi, openblasCompat
} :


stdenv.mkDerivation rec {
  pname = "scalapack";
  version = "2.0.2";

  src = fetchurl {
    url = "http://www.netlib.org/scalapack/scalapack-${version}.tgz";
    sha256 = "0p1r61ss1fq0bs8ynnx7xq4wwsdvs32ljvwjnx6yxr8gd6pawx0c";
  };

  # patch to rename outdated MPI functions
  patches = [ ./openmpi4.patch ];

  nativeBuildInputs = [ cmake openssh ];
  buildInputs = [ mpi gfortran openblasCompat ];

  enableParallelBuilding = true;

  doCheck = true;

  preConfigure = ''
    cmakeFlagsArray+=(
      -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF
      -DLAPACK_LIBRARIES="-lopenblas"
      -DBLAS_LIBRARIES="-lopenblas"
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

    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd`/lib
  '';

  meta = with stdenv.lib; {
    homepage = http://www.netlib.org/scalapack/;
    description = "Library of high-performance linear algebra routines for parallel distributed memory machines";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ costrouc markuskowa ];
  };

}
