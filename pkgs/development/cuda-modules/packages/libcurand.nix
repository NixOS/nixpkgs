args@{
  buildRedist,
  cuda_cudart,
  cudaMajorMinorVersion,
  lib,
}:
(import ../library.nix args) {
  pname = "libcurand";

  meta = {
    description = "Helper module for the cuBLASMp library that allows it to efficiently perform communications between different GPUs";
    longDescription = ''
      Communication Abstraction Library (CAL) is a helper module for the cuBLASMp library that allows it to
      efficiently perform communications between different GPUs.
    '';
    homepage = "https://developer.nvidia.com/curand";
    changelog = "https://docs.nvidia.com/cuda/cublasmp/release_notes";
  };
}
