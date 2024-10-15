{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  stdenv,
  wheel,
  which,
  torch,
  rich,
  typing-extensions,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
}@inputs:

buildPythonPackage rec {
  pname = "nerfacc";
  version = "0.5.3";
  pyproject = true;
  stdenv = if cudaSupport then cudaPackages.backendStdenv else inputs.stdenv;

  src = fetchFromGitHub {
    owner = "nerfstudio-project";
    repo = "nerfacc";
    rev = "v${version}";
    hash = "sha256-bXN4R+INs+RTjTkH2QbcZ97T9/rRyE2VwZvEeqYyY4M=";
  };

  build-system = [
    setuptools
    wheel
  ];

  nativeBuildInputs = lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
    which
  ];

  dependencies = [
    torch
    rich
    typing-extensions
  ];

  buildInputs = [ (lib.getOutput "cxxdev" torch) ];

  env =
    {
      BUILD_NO_CUDA = if cudaSupport then "0" else "1";
    }
    // lib.optionalAttrs cudaSupport {
      CUDA_HOME = "${cudaPackages.cuda_nvcc.__spliced.buildHost or cudaPackages.cuda_nvcc}";
      TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" torch.cudaCapabilities}";
    };

  pythonImportsCheck = [ "nerfacc" ];

  meta = {
    description = "A General NeRF Acceleration Toolbox in PyTorch";
    homepage = "https://github.com/nerfstudio-project/nerfacc";
    changelog = "https://github.com/nerfstudio-project/nerfacc/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
