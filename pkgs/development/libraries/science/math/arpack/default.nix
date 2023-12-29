{ lib, stdenv, fetchFromGitHub, cmake
, gfortran, blas, lapack, eigen
, useMpi ? false
, mpi
, openssh
, igraph
}:

# MPI version can only be built with LP64 interface.
# See https://github.com/opencollab/arpack-ng#readme
assert useMpi -> !blas.isILP64;

stdenv.mkDerivation rec {
  pname = "arpack";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "opencollab";
    repo = "arpack-ng";
    rev = version;
    sha256 = "sha256-HCvapLba8oLqx9I5+KDAU0s/dTmdWOEilS75i4gyfC0=";
  };

  nativeBuildInputs = [ cmake gfortran ];
  buildInputs = assert (blas.isILP64 == lapack.isILP64); [
    blas
    lapack
    eigen
  ] ++ lib.optional useMpi mpi;

  nativeCheckInputs = lib.optional useMpi openssh;

  doCheck = true;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DINTERFACE64=${if blas.isILP64 then "1" else "0"}"
    "-DMPI=${if useMpi then "ON" else "OFF"}"
  ];

  preCheck = ''
    # Prevent tests from using all cores
    export OMP_NUM_THREADS=2
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libblas.dylib ${blas}/lib/libblas.dylib $out/lib/libarpack.dylib
  '';

  passthru = {
    inherit (blas) isILP64;
    tests = {
      inherit igraph;
    };
  };

  meta = {
    homepage = "https://github.com/opencollab/arpack-ng";
    changelog = "https://github.com/opencollab/arpack-ng/blob/${src.rev}/CHANGES";
    description = ''
      A collection of Fortran77 subroutines to solve large scale eigenvalue
      problems.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ttuegel dotlambda ];
    platforms = lib.platforms.unix;
  };
}
