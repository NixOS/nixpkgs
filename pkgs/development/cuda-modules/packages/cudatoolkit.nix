{
  lib,
  symlinkJoin,
  backendStdenv,
  cudaAtLeast,
  cudaMajorMinorVersion,
  cuda_cccl ? null,
  cuda_crt ? null,
  cuda_cudart ? null,
  cuda_cuobjdump ? null,
  cuda_cupti ? null,
  cuda_cuxxfilt ? null,
  cuda_gdb ? null,
  cuda_nvcc ? null,
  cuda_nvdisasm ? null,
  cuda_nvml_dev ? null,
  cuda_nvprune ? null,
  cuda_nvrtc ? null,
  cuda_nvtx ? null,
  cuda_profiler_api ? null,
  cuda_sanitizer_api ? null,
  libcublas ? null,
  libcufft ? null,
  libcurand ? null,
  libcusolver ? null,
  libcusparse ? null,
  libnpp ? null,
}:

let
  # Retrieve all the outputs of a package except for the "static" output.
  getAllOutputs =
    p: lib.concatMap (output: lib.optionals (output != "static") [ p.${output} ]) p.outputs;

  hostPackages = [
    cuda_cuobjdump
    cuda_gdb
    cuda_nvcc
    cuda_nvdisasm
    cuda_nvprune
  ];
  targetPackages = [
    cuda_cccl
    cuda_cudart
    cuda_cupti
    cuda_cuxxfilt
    cuda_nvml_dev
    cuda_nvrtc
    cuda_nvtx
    cuda_profiler_api
    cuda_sanitizer_api
    libcublas
    libcufft
    libcurand
    libcusolver
    libcusparse
    libnpp
  ]
  ++ lib.optionals (cudaAtLeast "13") [
    cuda_crt
  ];

  # This assumes we put `cudatoolkit` in `buildInputs` instead of `nativeBuildInputs`:
  allPackages = (map (p: p.__spliced.buildHost or p) hostPackages) ++ targetPackages;
in
symlinkJoin rec {
  name = "cuda-merged-${cudaMajorMinorVersion}";
  version = cudaMajorMinorVersion;

  paths = builtins.concatMap getAllOutputs allPackages;

  passthru = {
    cc = lib.warn "cudaPackages.cudatoolkit is deprecated, refer to the manual and use splayed packages instead" backendStdenv.cc;
    lib = symlinkJoin {
      inherit name;
      paths = map (p: lib.getLib p) allPackages;
    };
  };

  meta = {
    description = "Wrapper substituting the deprecated runfile-based CUDA installation";
    license = lib.licenses.nvidiaCudaRedist;
    teams = [ lib.teams.cuda ];
  };
}
