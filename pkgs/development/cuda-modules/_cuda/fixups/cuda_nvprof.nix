{
  cuda_cudart,
  cuda_cupti,
  lib,
}:
prevAttrs: {
  allowFHSReferences = true;

  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    (lib.getOutput "stubs" cuda_cudart)
    cuda_cupti
  ];

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "bin"
        "lib"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Collect and view profiling data from the command-line";
    longDescription = ''
      The `nvprof` profiling tool enables you to collect and view profiling data from the command-line. `nvprof`
      enables the collection of a timeline of CUDA-related activities on both CPU and GPU, including kernel execution,
      memory transfers, memory set and CUDA API calls and events or metrics for CUDA kernels. Profiling options are
      provided to `nvprof` through command-line options. Profiling results are displayed in the console after the
      profiling data is collected, and may also be saved for later viewing by either `nvprof` or the Visual Profiler.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/cuda/profiler-users-guide#nvprof";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_nvprof";
    changelog = "https://docs.nvidia.com/cuda/profiler-users-guide#changelog";
  };
}
