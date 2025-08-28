{
  _cuda,
  libcal ? null,
  libcublas,
  nvshmem ? null, # TODO(@connorbaker): package this
}:
prevAttrs: {
  # TODO: Looks like the minimum supported capability is 7.0 as of the latest:
  # https://docs.nvidia.com/cuda/cublasmp/getting_started/index.html
  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    libcal
    libcublas
  ];

  passthru = prevAttrs.passthru or { } // {
    platformAssertions =
      prevAttrs.passthru.platformAssertions or [ ]
      ++ _cuda.lib._mkMissingPackagesAssertions { inherit libcal nvshmem; };

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
    description = "High-performance, multi-process, GPU-accelerated library for distributed basic dense linear algebra";
    longDescription = ''
      NVIDIA cuBLASMp is a high-performance, multi-process, GPU-accelerated library for distributed basic dense linear
      algebra.

      cuBLASMp is compatible with 2D block-cyclic data layout and provides PBLAS-like C APIs.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/cuda/cublasmp";
    downloadPage = "https://developer.download.nvidia.com/compute/cublasmp/redist/libcublasmp";
    changelog = "https://docs.nvidia.com/cuda/cublasmp/release_notes";
  };
}
