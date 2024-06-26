{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  mpiCheckPhaseHook,
  pkg-config,
  fypp,
  gfortran,
  blas,
  lapack,
  python3,
  libxsmm,
  mpi,
  openssh,
}:

stdenv.mkDerivation rec {
  pname = "dbcsr";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "cp2k";
    repo = "dbcsr";
    rev = "v${version}";
    hash = "sha256-+xSxfrzsxBdb424F/3mIETleEPoETxU0LB0OBJrR7gw=";
  };

  postPatch = ''
    patchShebangs .

    # Force build of shared library, otherwise just static.
    substituteInPlace src/CMakeLists.txt \
      --replace 'add_library(dbcsr ''${DBCSR_SRCS})' 'add_library(dbcsr SHARED ''${DBCSR_SRCS})' \
      --replace 'add_library(dbcsr_c ''${DBCSR_C_SRCS})' 'add_library(dbcsr_c SHARED ''${DBCSR_C_SRCS})'

    # Avoid calling the fypp wrapper script with python again. The nix wrapper took care of that.
    substituteInPlace cmake/fypp-sources.cmake \
      --replace 'COMMAND ''${Python_EXECUTABLE} ''${FYPP_EXECUTABLE}' 'COMMAND ''${FYPP_EXECUTABLE}'
  '';

  nativeBuildInputs = [
    gfortran
    python3
    cmake
    pkg-config
    fypp
  ];

  buildInputs = [
    blas
    lapack
    libxsmm
  ];

  propagatedBuildInputs = [ mpi ];

  preConfigure = ''
    export PKG_CONFIG_PATH=${libxsmm}/lib
  '';

  cmakeFlags = [
    "-DUSE_OPENMP=ON"
    "-DUSE_SMM=libxsmm"
    "-DWITH_C_API=ON"
    "-DBUILD_TESTING=ON"
    "-DTEST_OMP_THREADS=2"
    "-DTEST_MPI_RANKS=2"
    "-DENABLE_SHARED=ON"
    "-DUSE_MPI=ON"
  ];

  checkInputs = [
    openssh
    mpiCheckPhaseHook
  ];

  doCheck = true;

  meta = with lib; {
    description = "Distributed Block Compressed Sparse Row matrix library";
    license = licenses.gpl2Only;
    homepage = "https://github.com/cp2k/dbcsr";
    maintainers = [ maintainers.sheepforce ];
  };
}
