{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cudaPackages,
  config,
  setuptools,
  torch,
  ninja,
  wheel,
  cudaSupport ? config.cudaSupport,
  autoAddDriverRunpath,
}:

assert cudaSupport -> torch.cudaSupport;

buildPythonPackage rec {
  pname = "fast-hadamard-transform";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "fast-hadamard-transform";
    tag = "v${version}";
    hash = "sha256-WFrjTQac+mUcVqW1QmDxbcXzYLU/YSgTnjgQHImpoTc=";
  };

  nativeBuildInputs = lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ];
  build-system = [
    setuptools
    ninja
    wheel
  ];

  dependencies = [
    torch
  ];


  env =
    {
      FORCE_CUDA = cudaSupport;
    }
    // lib.optionalAttrs cudaSupport {
      CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}";
      TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" torch.cudaCapabilities}";
    };



  pythonImportsCheck = [ "fast_hadamard_transform" ];

  meta = {
    description = "Fast Hadamard transform in CUDA";
    homepage = "https://github.com/Dao-AILab/fast-hadamard-transform";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ osbm ];
    broken = !cudaSupport;
  };
}
