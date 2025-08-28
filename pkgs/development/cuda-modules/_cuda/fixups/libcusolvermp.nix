{
  _cuda,
  cuda_cudart,
  libcal ? null,
  libcublas,
  libcusolver,
}:
prevAttrs: {
  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    cuda_cudart
    libcal
    libcublas
    libcusolver
  ];

  passthru = prevAttrs.passthru or { } // {
    platformAssertions =
      prevAttrs.passthru.platformAssertions or [ ]
      ++ _cuda.lib._mkMissingPackagesAssertions { inherit libcal; };

    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "dev"
        "include"
        "lib"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "High-performance, distributed-memory, GPU-accelerated library that provides tools for solving dense linear systems and eigenvalue problems";
    longDescription = ''
      The NVIDIA cuSOLVERMp library is a high-performance, distributed-memory, GPU-accelerated library that provides
      tools for solving dense linear systems and eigenvalue problems.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://developer.nvidia.com/cusolver";
  };
}
