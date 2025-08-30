_: prevAttrs: {
  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "dev"
        "include"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "API for profiling CUDA runtime";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_profiler_api";
  };
}
