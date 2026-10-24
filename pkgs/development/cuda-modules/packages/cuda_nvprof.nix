{
  redistSystem,
  buildRedist,
  cuda_cudart,
  cuda_cupti,
  cudaAtLeast,
  cudaMajorMinorVersion,
  lib,
}:
buildRedist {
  redistName = "cuda";
  pname = "cuda_nvprof";

  allowFHSReferences = true;

  outputs = [
    "out"
  ]
  # The `bin` and `lib` output are only available on SBSA starting with CUDA 11.8.
  ++ lib.optionals (redistSystem != "linux-sbsa" || cudaAtLeast "11.8") [
    "bin"
    "lib"
  ];

  buildInputs = [
    cuda_cupti
  ];

  propagatedBuildInputs = [ cuda_cudart ];

  # These injection libraries have no public headers in the redistributable.
  postPatch = ''
    substituteInPlace share/pkgconfig/{cuinj64,accinj64}-${cudaMajorMinorVersion}.pc \
      --replace-fail "includedir=''${!outputInclude:?}/include" "" \
      --replace-fail 'Cflags: -I''${includedir}' ""
    # cuinj64 has unresolved driver symbols; linking its advertised interface
    # needs the driver stub even when the application calls no CUDA API itself.
    substituteInPlace share/pkgconfig/cuinj64-${cudaMajorMinorVersion}.pc \
      --replace-fail 'Libs:' $'Requires: cuda-${cudaMajorMinorVersion}\nLibs:'
  '';

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
