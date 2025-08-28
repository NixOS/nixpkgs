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
    description = "Helper module for the cuBLASMp library that allows it to efficiently perform communications between different GPUs";
    longDescription = ''
      Communication Abstraction Library (CAL) is a helper module for the cuBLASMp library that allows it to
      efficiently perform communications between different GPUs.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://developer.nvidia.com/curand";
    changelog = "https://docs.nvidia.com/cuda/cublasmp/release_notes";
  };
}
