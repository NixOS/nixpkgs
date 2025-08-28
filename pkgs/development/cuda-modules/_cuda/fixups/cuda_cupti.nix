{ backendStdenv, lib }:
prevAttrs: {
  allowFHSReferences = true;

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "dev"
        "include"
        "lib"
        "samples"
      ]
      ++ lib.optionals (backendStdenv.hostNixSystem == "x86_64-linux") [ "static" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "C-based interface for creating profiling and tracing tools designed for CUDA applications";
    longDescription = ''
      The CUDA Profiling Tools Interface (CUPTI) provides a C-based interface for creating profiling and tracing tools
      designed for CUDA applications.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/cupti";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_cupti";
    changelog = "https://docs.nvidia.com/cupti/release-notes/release-notes.html";
  };
}
