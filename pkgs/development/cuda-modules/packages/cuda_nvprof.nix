{
  buildRedist,
  cuda_cupti,
}:
buildRedist {
  redistName = "cuda";
  pname = "cuda_nvprof";

  allowFHSReferences = true;

  outputs = [
    "out"
    "bin"
    "lib"
  ];

  buildInputs = [
    cuda_cupti
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libcuda.so.1"
  ];

  meta = {
    description = "Collect and view profiling data from the command-line";
    longDescription = ''
      The `nvprof` profiling tool enables you to collect and view profiling data from the command-line. `nvprof`
      enables the collection of a timeline of CUDA-related activities on both CPU and GPU, including kernel execution,
      memory transfers, memory set and CUDA API calls and events or metrics for CUDA kernels. Profiling options are
      provided to `nvprof` through command-line options. Profiling results are displayed in the console after the
      profiling data is collected, and may also be saved for later viewing by either `nvprof` or the Visual Profiler.
    '';
    homepage = "https://docs.nvidia.com/cuda/profiler-users-guide#nvprof";
    changelog = "https://docs.nvidia.com/cuda/profiler-users-guide#changelog";
  };
}
