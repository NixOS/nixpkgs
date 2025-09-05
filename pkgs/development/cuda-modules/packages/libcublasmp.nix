{
  _cuda,
  buildRedist,
  libcal ? null,
  libcublas,
  nvshmem ? null, # TODO(@connorbaker): package this
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
  buildInputs = [
    libcal
    libcublas
  ];

  platformAssertions = _cuda.lib._mkMissingPackagesAssertions { inherit libcal nvshmem; };

  meta = {
    description = "High-performance, multi-process, GPU-accelerated library for distributed basic dense linear algebra";
    longDescription = ''
      NVIDIA cuBLASMp is a high-performance, multi-process, GPU-accelerated library for distributed basic dense linear
      algebra.

      cuBLASMp is compatible with 2D block-cyclic data layout and provides PBLAS-like C APIs.
    '';
    homepage = "https://docs.nvidia.com/cuda/cublasmp";
    changelog = "https://docs.nvidia.com/cuda/cublasmp/release_notes";
    license = [ _cuda.lib.licenses.math_sdk_sla ];
  };
}
