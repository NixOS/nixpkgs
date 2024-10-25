{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  torch,
  iopath,
  cudaPackages,
  config,
  cudaSupport ? config.cudaSupport,
}:

assert cudaSupport -> torch.cudaSupport;

buildPythonPackage rec {
  pname = "pytorch3d";
  version = "0.7.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "pytorch3d";
    rev = "V${version}";
    hash = "sha256-DEEWWfjwjuXGc0WQInDTmtnWSIDUifyByxdg7hpdHlo=";
  };

  nativeBuildInputs = lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];
  build-system = [
    setuptools
    wheel
  ];
  dependencies = [
    torch
    iopath
  ];
  buildInputs = [ (lib.getOutput "cxxdev" torch) ];

  env =
    {
      FORCE_CUDA = cudaSupport;
    }
    // lib.optionalAttrs cudaSupport {
      TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" torch.cudaCapabilities}";
    };

  pythonImportsCheck = [ "pytorch3d" ];

  meta = {
    description = "FAIR's library of reusable components for deep learning with 3D data";
    homepage = "https://github.com/facebookresearch/pytorch3d";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      pbsds
      SomeoneSerge
    ];
  };
}
