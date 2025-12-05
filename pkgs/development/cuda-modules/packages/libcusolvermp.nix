{
  _cuda,
  buildRedist,
  cuda_cudart,
  libcublas,
  libcusolver,
  nccl,
}:
buildRedist {
  redistName = "cusolvermp";
  pname = "libcusolvermp";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  buildInputs = [
    cuda_cudart
    libcublas
    libcusolver
    nccl
  ];

  meta = {
    description = "High-performance, distributed-memory, GPU-accelerated library that provides tools for solving dense linear systems and eigenvalue problems";
    longDescription = ''
      The NVIDIA cuSOLVERMp library is a high-performance, distributed-memory, GPU-accelerated library that provides
      tools for solving dense linear systems and eigenvalue problems.
    '';
    homepage = "https://developer.nvidia.com/cusolver";
  };
}
