_: prevAttrs: {
  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "bin"
        "dev"
        "include"
        "static"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Decode low-level identifiers that have been mangled by CUDA C++ into user readable names";
    longDescription = ''
      cu++filt decodes (demangles) low-level identifiers that have been mangled by CUDA C++ into user readable names.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/cuda/cuda-binary-utilities#cu-filt";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_cuxxfilt";
  };
}
