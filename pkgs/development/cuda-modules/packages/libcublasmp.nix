{
  lib,
  buildRedist,
  libcublas,
  nccl,
}:
buildRedist {
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
  # NOTE: cuBLASMp has not depended on NVSHMEM since 0.8.0:
  # https://docs.nvidia.com/cuda/cublasmp/release_notes/index.html
  buildInputs = [
    libcublas
    nccl
  ];

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
    license = lib.licenses.nvidiaMath_sdk_sla;
  };
}
