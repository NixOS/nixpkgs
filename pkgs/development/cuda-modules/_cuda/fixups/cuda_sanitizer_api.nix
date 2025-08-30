_: prevAttrs: {
  allowFHSReferences = true;

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Enables the creation of sanitizing and tracing tools that target CUDA applications";
    longDescription = ''
      The Compute Sanitizer API enables the creation of sanitizing and tracing tools that target CUDA applications.
      Examples of such tools are memory and race condition checkers.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/compute-sanitizer/SanitizerApiGuide";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_sanitizer_api";
  };
}
