{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ninja,
  numpy,
  packaging,
  pybind11,
  torch,
  which,
}:

buildPythonPackage rec {
  pname = "monai";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Project-MONAI";
    repo = "MONAI";
    tag = version;
    hash = "sha256-tRHHldNQc8Rx/oXyAEMQwIYOVtzzNpwQo8V9TdWLtO8=";
    # fix source non-reproducibility due to versioneer + git-archive, as with Numba, Pytensor etc. derivations:
    postFetch = ''
      sed -i 's/git_refnames = "[^"]*"/git_refnames = " (tag: ${src.tag})"/' $out/monai/_version.py
    '';
  };

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES;
  '';

  build-system = [
    ninja
    which
  ];

  buildInputs = [ pybind11 ];

  dependencies = [
    numpy
    packaging
    torch
  ];

  env.BUILD_MONAI = 1;

  doCheck = false; # takes too long; tries to download data

  pythonImportsCheck = [
    "monai"
    "monai.apps"
    "monai.data"
    "monai.engines"
    "monai.handlers"
    "monai.inferers"
    "monai.losses"
    "monai.metrics"
    "monai.optimizers"
    "monai.networks"
    "monai.transforms"
    "monai.utils"
    "monai.visualize"
  ];

  meta = {
    description = "Pytorch framework (based on Ignite) for deep learning in medical imaging";
    homepage = "https://github.com/Project-MONAI/MONAI";
    changelog = "https://github.com/Project-MONAI/MONAI/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bcdarwin ];
  };
}
