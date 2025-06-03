{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  packaging,
  setuptools,
  torch,
  kornia-rs,
}:

buildPythonPackage rec {
  pname = "kornia";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "kornia";
    repo = "kornia";
    tag = "v${version}";
    hash = "sha256-pMCGL33DTnMLlxRbhBhRuR/ZA575+kbUJ59N3nuqpdI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    kornia-rs
    packaging
    torch
  ];

  pythonImportsCheck = [
    "kornia"
    "kornia.augmentation"
    "kornia.color"
    "kornia.contrib"
    "kornia.enhance"
    "kornia.feature"
    "kornia.filters"
    "kornia.geometry"
    "kornia.io"
    "kornia.losses"
    "kornia.metrics"
    "kornia.morphology"
    "kornia.tracking"
    "kornia.utils"
  ];

  doCheck = false; # tests hang with no single test clearly responsible

  meta = {
    homepage = "https://kornia.readthedocs.io";
    changelog = "https://github.com/kornia/kornia/releases/tag/v${version}";
    description = "Differentiable computer vision library";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
