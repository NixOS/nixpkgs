_: prevAttrs: {
  allowFHSReferences = true;

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
    description = "Runtime compilation library for CUDA C++";
    longDescription = ''
      NVRTC is a runtime compilation library for CUDA C++. It accepts CUDA C++ source code in character string form
      and creates handles that can be used to obtain the PTX.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/cuda/nvrtc";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_nvrtc";
  };
}
