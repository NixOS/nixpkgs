_: prevAttrs: {
  allowFHSReferences = true;

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Cross-platform performance profiling tool for optimizing CUDA C/C++ applications";
    longDescription = ''
      The NVIDIA Visual Profiler is a cross-platform performance profiling tool that delivers developers vital
      feedback for optimizing CUDA C/C++ applications.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://developer.nvidia.com/nvidia-visual-profiler";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_nvvp";
  };
}
