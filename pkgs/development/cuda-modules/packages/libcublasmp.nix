{
  _cuda,
  buildRedist,
  callPackage,
  cuda_cudart,
  lib,
  libcublas,
  libnvshmem,
  nccl,
}:
buildRedist (finalAttrs: {
  redistName = "cublasmp";
  pname = "libcublasmp";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  # TODO: Looks like the minimum supported capability is 7.0 as of the latest:
  # https://docs.nvidia.com/cuda/cublasmp/getting_started/index.html
  buildInputs = [
    libnvshmem
  ];

  propagatedBuildInputs = [
    libcublas
    nccl
  ];

  passthru.tests.headers = callPackage ./tests/public-headers.nix {
    package = finalAttrs.finalPackage;
    headers = [ "cublasmp.h" ];
    libraries = [ "cublasmp" ];
    symbols = [ "cublasMpGetVersion" ];
    driverLibraries = [ "${lib.getOutput cuda_cudart.outputStubs cuda_cudart}/lib/stubs/libcuda.so" ];
  };

  autoPatchelfIgnoreMissingDeps = [
    "libcuda.so.1"
  ];

  meta = {
    description = "High-performance, multi-process, GPU-accelerated library for distributed basic dense linear algebra";
    longDescription = ''
      NVIDIA cuBLASMp is a high-performance, multi-process, GPU-accelerated library for distributed basic dense linear
      algebra.

      cuBLASMp is compatible with 2D block-cyclic data layout and provides PBLAS-like C APIs.
    '';
    homepage = "https://docs.nvidia.com/cuda/cublasmp";
    changelog = "https://docs.nvidia.com/cuda/cublasmp/release_notes";
    license = _cuda.lib.licenses.math_sdk_sla;
  };
})
