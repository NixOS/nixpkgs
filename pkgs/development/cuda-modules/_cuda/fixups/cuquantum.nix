{
  cuda_cudart,
  libcublas,
  libcusolver,
  libcutensor,
}:
prevAttrs: {
  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    cuda_cudart
    libcublas
    libcusolver
    libcutensor
  ];

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "dev"
        "include"
        "lib"
        "static"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Set of high-performance libraries and tools for accelerating quantum computing simulations at both the circuit and device level by orders of magnitude";
    longDescription = ''
      NVIDIA cuQuantum SDK is a set of high-performance libraries and tools for accelerating quantum computing
      simulations at both the circuit and device level by orders of magnitude.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://developer.nvidia.com/cuquantum-sdk";
    downloadPage = "https://developer.download.nvidia.com/compute/cuquantum/redist/cuquantum";
    changelog = "https://docs.nvidia.com/cuda/cuquantum/latest/cuquantum-sdk-release-notes.html";
  };
}
