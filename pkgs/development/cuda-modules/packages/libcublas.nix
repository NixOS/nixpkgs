{
  buildRedist,
  cuda_cudart,
  cudaMajorMinorVersion,
  cuda_nvrtc,
  lib,
}:
buildRedist (finalAttrs: {
  redistName = "cuda";
  pname = "libcublas";

  # libcublasLt dlopens NVRTC to compile kernels at runtime; absent before 12.8.
  appendRunpaths = lib.optionals (lib.versionAtLeast finalAttrs.version "12.8") [
    "${lib.getLib cuda_nvrtc}/lib" # libnvrtc.so.%s
  ];

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
    "stubs"
  ];

  # Public headers include CUDA types; publish the same dependencies to
  # stdenv and to pkg-config consumers.
  propagatedBuildInputs = [ cuda_cudart ];

  postPatch = ''
    substituteInPlace share/pkgconfig/cublas-${cudaMajorMinorVersion}.pc \
      --replace-fail 'Cflags:' $'Requires: cudart-${cudaMajorMinorVersion}\nCflags:'
  '';

  meta = {
    description = "CUDA Basic Linear Algebra Subroutine library";
    longDescription = ''
      The cuBLAS library is an implementation of BLAS (Basic Linear Algebra Subprograms) on top of the NVIDIA CUDA runtime.
    '';
    homepage = "https://developer.nvidia.com/cublas";
  };
})
