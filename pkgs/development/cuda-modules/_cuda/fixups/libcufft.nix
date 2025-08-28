_: prevAttrs: {
  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "dev"
        "include"
        "lib"
        "static"
        "stubs"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "High-performance FFT product CUDA library";
    homepage = "https://developer.nvidia.com/cufft";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/libcufft";
  };
}
