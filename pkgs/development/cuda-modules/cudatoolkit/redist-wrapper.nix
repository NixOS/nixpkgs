{
  lib,
  symlinkJoin,
  backendStdenv,
  cudaAtLeast,
  cudaOlder,
  cudatoolkit-legacy-runfile,
  cudaVersion,
  cuda_cccl ? null,
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
  cuda_opencl ? null,
  cuda_profiler_api ? null,
  cuda_sanitizer_api ? null,
  libcublas ? null,
  libcufft ? null,
  libcurand ? null,
  libcusolver ? null,
  libcusparse ? null,
  libnpp ? null,
  libnvjitlink ? null,
}:

let
  inherit (lib.attrsets) getBin getDev getLib;
  inherit (lib.lists) concatMap map optionals;
  getAllOutputs = p: [
    (getBin p)
    (getLib p)
    (getDev p)
  ];
  hostPackages = [
    cuda_cuobjdump
    cuda_gdb
    cuda_nvcc
    cuda_nvdisasm
    cuda_nvprune
  ];
  targetPackages =
    [
      cuda_cccl
      cuda_cudart
      cuda_cudart.static # NOTE: We need the static output specifically
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
    ++ optionals (cudaAtLeast "12.0") [
      cuda_opencl
      libnvjitlink
    ];

  # This assumes we put `cudatoolkit` in `buildInputs` instead of `nativeBuildInputs`:
  allPackages = (map (p: p.__spliced.buildHost or p) hostPackages) ++ targetPackages;
in

if cudaOlder "11.4" then
  cudatoolkit-legacy-runfile
else
  symlinkJoin rec {
    name = "cuda-merged-${cudaVersion}";
    version = cudaVersion;

    paths = concatMap getAllOutputs allPackages;

    passthru = {
      cc = lib.warn "cudaPackages.cudatoolkit is deprecated, refer to the manual and use splayed packages instead" backendStdenv.cc;
      lib = symlinkJoin {
        inherit name;
        paths = map getLib allPackages;
      };
    };

    meta = with lib; {
      description = "Wrapper substituting the deprecated runfile-based CUDA installation";
      license = licenses.nvidiaCuda;
    };
  }
