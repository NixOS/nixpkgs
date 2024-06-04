{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pythonAtLeast,
  ninja,
  ignite,
  numpy,
  pybind11,
  torch,
  which,
}:

buildPythonPackage rec {
  pname = "monai";
  version = "1.3.1";
  pyproject = true;
  # upper bound due to use of `distutils`; remove after next release:
  disabled = pythonOlder "3.8" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "Project-MONAI";
    repo = "MONAI";
    rev = "refs/tags/${version}";
    hash = "sha256-YjEJbDM9+PiC3Kse8NA/b/yJBsReaK6yIyEB9uktiEc=";
  };

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES;
  '';

  nativeBuildInputs = [
    ninja
    which
  ];
  buildInputs = [ pybind11 ];
  propagatedBuildInputs = [
    numpy
    torch
    ignite
  ];

  BUILD_MONAI = 1;

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

  meta = with lib; {
    description = "Pytorch framework (based on Ignite) for deep learning in medical imaging";
    homepage = "https://github.com/Project-MONAI/MONAI";
    changelog = "https://github.com/Project-MONAI/MONAI/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bcdarwin ];
  };
}
