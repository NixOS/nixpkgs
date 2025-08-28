_: prevAttrs: {
  passthru = prevAttrs.passthru or { } // {
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
    description = "Low-level API for heterogeneous computing that runs on CUDA-powered GPUs";
    longDescription = ''
      OpenCL™ (Open Computing Language) is a low-level API for heterogeneous computing that runs on CUDA-powered GPUs.
      Using the OpenCL API, developers can launch compute kernels written using a limited subset of the C programming
      language on a GPU.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://developer.nvidia.com/opencl";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_opencl";
  };
}
