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
    description = "C-based Application Programming Interface (API) for annotating events, code ranges, and resources in your applications";
    longDescription = ''
      NVTX is a cross-platform API for annotating source code to provide contextual information to developer tools.

      The NVTX API is written in C, with wrappers provided for C++ and Python.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://github.com/NVIDIA/NVTX";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_nvtx";
    changelog = "https://github.com/NVIDIA/NVTX/releases";
  };
}
