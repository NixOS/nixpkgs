{ lib
, stdenv
, fetchurl
, cmake
, ninja
, gfortran
, libpthreadstubs
, lapack
, blas
, cudaPackages
, hip
, hipblas
, hipsparse
, openmp
, useCUDA ? true
, useROCM ? false
, gpuTargets ? [ ]
}:

let
  inherit (cudaPackages) cudatoolkit cudaFlags;
in stdenv.mkDerivation (finalAttrs: {
  pname = "magma";
  version = "2.6.2";

  src = fetchurl {
    name = "magma-${finalAttrs.version}.tar.gz";
    url = "https://icl.cs.utk.edu/projectsfiles/magma/downloads/magma-${finalAttrs.version}.tar.gz";
    hash = "sha256-dbVU2rAJA+LRC5cskT5Q5/iMvGLzrkMrWghsfk7aCnE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    gfortran
  ];

  buildInputs = [
    libpthreadstubs
    lapack
    blas
  ] ++ lib.optionals useCUDA [
    cudatoolkit
  ] ++ lib.optionals useROCM [
    hip
    hipblas
    hipsparse
    openmp
  ];

  cmakeFlags = lib.optionals useCUDA [
    "-DCMAKE_C_COMPILER=${cudatoolkit.cc}/bin/gcc"
    "-DCMAKE_CXX_COMPILER=${cudatoolkit.cc}/bin/g++"
    "-DMAGMA_ENABLE_CUDA=ON"
    "-DGPU_TARGET=${builtins.concatStringsSep "," cudaFlags.cudaRealArchs}"
  ] ++ lib.optionals useROCM [
    "-DCMAKE_C_COMPILER=${hip}/bin/hipcc"
    "-DCMAKE_CXX_COMPILER=${hip}/bin/hipcc"
    "-DMAGMA_ENABLE_HIP=ON"
    "-DGPU_TARGET=${builtins.concatStringsSep "," (if gpuTargets == [ ] then hip.gpuTargets else gpuTargets)}"
  ];

  buildFlags = [
    "magma"
    "magma_sparse"
  ];

  doCheck = false;

  passthru = {
    inherit cudatoolkit;
  };

  meta = with lib; {
    description = "Matrix Algebra on GPU and Multicore Architectures";
    license = licenses.bsd3;
    homepage = "http://icl.cs.utk.edu/magma/index.html";
    platforms = platforms.unix;
    maintainers = with maintainers; [ tbenst ];
    # CUDA and ROCm are mutually exclusive
    broken = useCUDA && useROCM || useCUDA && versionOlder cudatoolkit.version "9";
  };
})
