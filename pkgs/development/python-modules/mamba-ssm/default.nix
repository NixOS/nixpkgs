{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  causal-conv1d,
  einops,
  ninja,
  setuptools,
  torch,
  transformers,
  triton,
  cudaPackages,
  rocmPackages,
  config,
  cudaSupport ? config.cudaSupport,
  which,
}:

buildPythonPackage rec {
  pname = "mamba";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "state-spaces";
    repo = "mamba";
    tag = "v${version}";
    hash = "sha256-R702JjM3AGk7upN7GkNK8u1q4ekMK9fYQkpO6Re45Ng=";
  };

  build-system = [
    ninja
    setuptools
    torch
  ];

  nativeBuildInputs = [ which ];

  buildInputs = (
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
  );

  dependencies = [
    causal-conv1d
    einops
    torch
    transformers
    triton
  ];

  env = {
    MAMBA_FORCE_BUILD = "TRUE";
  }
  // lib.optionalAttrs cudaSupport { CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}"; };

  # pytest tests not enabled due to nvidia GPU dependency
  pythonImportsCheck = [ "mamba_ssm" ];

  meta = with lib; {
    description = "Linear-Time Sequence Modeling with Selective State Spaces";
    homepage = "https://github.com/state-spaces/mamba";
    license = licenses.asl20;
    # The package requires CUDA or ROCm, the ROCm build hasn't
    # been completed or tested, so broken if not using cuda.
    broken = !cudaSupport;
  };
}
