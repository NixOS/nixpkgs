{ lib
, stdenv
, fetchFromGitHub
, cmake
, mpi
, blas
, lapack
, openssh
}:

stdenv.mkDerivation rec {
  pname = "hypre";
  version = "2.28.0";
  # For version info for PETSc, see petsc/config/BuildSystem/config/packages/hypre.py

  src = fetchFromGitHub {
    owner = "hypre-space";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/k2ijrre1xYT5cYrW4QbH3spgifWErXE7CnQFH01cnI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ mpi blas lapack ];
  checkInputs = lib.optionals (mpi.pname == "openmpi") [ openssh ];

  cmakeDir = "../src";
  cmakeFlags = [
    "-DHYPRE_BUILD_TESTS=ON"
    "-DHYPRE_ENABLE_HYPRE_BLAS=OFF"
    "-DHYPRE_ENABLE_HYPRE_LAPACK=OFF"
  ];

  doCheck = true;
  # Checks taken from the global Makefile, target `check`
  checkPhase = ''
    runHook preCheck

    TESTS="ij struct sstruct"
    cp $src/src/test/TEST_sstruct/sstruct.in.default .
    for test_name in $TESTS; do
      [ -n "$($PWD/test/$test_name > /dev/null)" ] && exit 1
    done

    runHook postCheck
  '';

  meta = {
    description = "Parallel solvers for sparse linear systems featuring multigrid methods";
    homepage = "https://www.llnl.gov/casc/hypre/";
    downloadPage = "https://github.com/hypre-space/hypre/releases";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
