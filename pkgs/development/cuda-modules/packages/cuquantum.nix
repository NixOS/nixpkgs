{
  buildRedist,
  cuda_cudart,
  libcublas,
  libcurand,
  libcusolver,
  libcutensor,
}:
buildRedist {
  redistName = "cuquantum";
  pname = "cuquantum";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
  ];

  buildInputs = [
    cuda_cudart
    libcublas
    libcurand
    libcusolver
    libcutensor
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libnvidia-ml.so.1"
  ];

  meta = {
    description = "Set of high-performance libraries and tools for accelerating quantum computing simulations at both the circuit and device level by orders of magnitude";
    longDescription = ''
      NVIDIA cuQuantum SDK is a set of high-performance libraries and tools for accelerating quantum computing
      simulations at both the circuit and device level by orders of magnitude.
    '';
    homepage = "https://developer.nvidia.com/cuquantum-sdk";
    changelog = "https://docs.nvidia.com/cuda/cuquantum/latest/cuquantum-sdk-release-notes.html";
  };
}
