{
  libcufft,
  libcurand,
  libGLU,
  libglut,
  libglvnd,
  mesa,
}:
prevAttrs: {
  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    libcufft
    libcurand
    libGLU
    libglut
    libglvnd
    mesa
  ];

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Pre-built applications which use CUDA";
    longDescription = ''
      The CUDA Demo Suite contains pre-built applications which use CUDA. These applications demonstrate the
      capabilities and details of NVIDIA GPUs.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/cuda/demo-suite";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_demo_suite";
  };
}
