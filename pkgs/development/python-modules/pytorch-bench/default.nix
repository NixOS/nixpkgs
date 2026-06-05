{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  codecarbon,
  colorama,
  matplotlib,
  numpy,
  nvidia-ml-py,
  torch,
  torchprofile,
  tqdm,

  # passthru
  nix-update-script,
}:

buildPythonPackage {
  pname = "pytorch-bench";
  version = "0-unstable-2025-05-05";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MaximeGloesener";
    repo = "torch-benchmark";
    rev = "f22db3b2e5920cf084e088e7748e3ffd32343853";
    hash = "sha256-+jd+H5hL+DotlLaBiaixb//hxyvEF6aAJYSHX1hfsP8=";
  };

  build-system = [
    setuptools
  ];

  pythonRemoveDeps = [
    # pynvml is deprecated and replaced by nvidia-ml-py which provides the same API
    "pynvml"
  ];
  dependencies = [
    codecarbon
    colorama
    matplotlib
    numpy
    nvidia-ml-py
    torch
    torchprofile
    tqdm
  ];

  pythonImportsCheck = [ "pytorch_bench" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Benchmarking tool for torch";
    homepage = "https://github.com/MaximeGloesener/torch-benchmark";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
