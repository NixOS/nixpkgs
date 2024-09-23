{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  einops,
  ninja,
  setuptools,
  torch,
  transformers,
  triton,
  cudaPackages,
  config,
  cudaSupport ? config.cudaSupport,
  which,
  git,
  psutil
}:

let
  cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    rev = "refs/tags/v3.5.0";
    sha256 = "sha256-D/s7eYsa5l/mfx73tE4mnFcTQdYqGmXa9d9TCryw4e4=";
  };
in

buildPythonPackage rec {
  pname = "flash-attn";
  version = "2.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "flash-attention";
    rev = "refs/tags/v${version}";
    hash = "sha256-9AmmoUlyh4x0CuasZeXML7N3TETmG0vhHMm8cirsblk=";
  };

  build-system = [
    ninja
    setuptools
    torch
    psutil
  ];

  nativeBuildInputs = [ which git ];

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
        cutlass
      ]
    )
  );

  dependencies = [
    einops
    torch
    triton
  ];

  env = {
    FLASHATTENTION_FORCE_BUILD = "TRUE";
  } // lib.optionalAttrs cudaSupport { CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}"; };

  # pytest tests not enabled due to nvidia GPU dependency
  pythonImportsCheck = [ "flash_attn" ];

  meta = with lib; {
    description = "Fast and Memory-Efficient Exact Attention with IO-Awareness";
    homepage = "https://github.com/Dao-AILab/flash-attention";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cfhammill ];
    # The package requires CUDA or ROCm, the ROCm build hasn't
    # been completed or tested, so broken if not using cuda.
    broken = !cudaSupport;
  };
}
