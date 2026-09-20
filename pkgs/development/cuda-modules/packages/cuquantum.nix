{
  buildRedist,
  callPackage,
  cuda_cudart,
  cuda_nvml_dev,
  lib,
  libcublas,
  libcurand,
  libcusolver,
  libcutensor,
}:
buildRedist (finalAttrs: {
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
    libcublas
    libcurand
    libcusolver
    libcutensor
  ];

  propagatedBuildInputs = [ cuda_cudart ];

  passthru.tests.headers = callPackage ./tests/public-headers.nix {
    package = finalAttrs.finalPackage;
    headers = [
      "custatevec.h"
      "cutensornet.h"
      "cudensitymat.h"
    ];
    libraries = [
      "custatevec"
      "cutensornet"
      "cudensitymat"
    ];
    symbols = [
      "custatevecGetVersion"
      "cutensornetGetVersion"
      "cudensitymatGetVersion"
    ];
    driverLibraries = [
      "${lib.getOutput cuda_nvml_dev.outputStubs cuda_nvml_dev}/lib/stubs/libnvidia-ml.so"
    ];
  };

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
})
