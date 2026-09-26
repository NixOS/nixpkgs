{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "libcurand";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
    "stubs"
  ];

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
