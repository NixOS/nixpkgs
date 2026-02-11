{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ninja,
  setuptools,
  torch,
  cudaPackages,
  rocmPackages,
  config,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
  rocmGpuTargets ? rocmPackages.clr.localGpuTargets or rocmPackages.clr.gpuTargets,
  which,
}:

buildPythonPackage rec {
  pname = "causal-conv1d";
  version = "1.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "causal-conv1d";
    tag = "v${version}";
    hash = "sha256-ELuvnKP2g1I2SuaWWiibXh/oDzp4n0vXkm4oeNPOdIw=";
  };

  build-system = [
    ninja
    setuptools
    torch
  ];

  nativeBuildInputs = [ which ] ++ lib.optionals rocmSupport [ rocmPackages.clr ];

  buildInputs =
    lib.optionals cudaSupport (
      with cudaPackages;
      [
        cuda_cudart # cuda_runtime.h, -lcudart
        cuda_cccl
        libcusparse # cusparse.h
        libcusolver # cusolverDn.h
        cuda_nvcc
        libcublas
      ]
    )
    ++ lib.optionals rocmSupport (
      with rocmPackages;
      [
        rocm-core
        rocm-device-libs
        rocm-runtime
        rocm-comgr
        hipblas
        rocblas
        hipcub
        rocprim
      ]
    );

  dependencies = [
    torch
  ];

  # pytest tests not enabled due to GPU dependency
  pythonImportsCheck = [ "causal_conv1d" ];

  env = {
    CAUSAL_CONV1D_FORCE_BUILD = "TRUE";
  }
  // lib.optionalAttrs cudaSupport { CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}"; }
  // lib.optionalAttrs rocmSupport {
    ROCM_PATH = "${rocmPackages.clr}";
    HIP_ARCHITECTURES = builtins.concatStringsSep "," rocmGpuTargets;
    CPLUS_INCLUDE_PATH = lib.makeSearchPath "include" [
      rocmPackages.hipcub
      rocmPackages.rocprim
    ];
  };

  meta = {
    description = "Causal depthwise conv1d in CUDA with a PyTorch interface";
    homepage = "https://github.com/Dao-AILab/causal-conv1d";
    license = lib.licenses.bsd3;

    # The package requires either CUDA or ROCm.
    # It doesn't work without either, nor with both.
    broken = cudaSupport == rocmSupport;
  };
}
