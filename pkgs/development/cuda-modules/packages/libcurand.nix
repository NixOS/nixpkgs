{
  buildRedist,
  cuda_cudart,
  cudaMajorMinorVersion,
}:
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

  # Public headers include CUDA types; publish the same dependencies to
  # stdenv and to pkg-config consumers.
  propagatedBuildInputs = [ cuda_cudart ];

  postPatch = ''
    substituteInPlace share/pkgconfig/curand-${cudaMajorMinorVersion}.pc \
      --replace-fail 'Cflags:' $'Requires: cudart-${cudaMajorMinorVersion}\nCflags:'
  '';

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
