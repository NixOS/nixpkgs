{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  setuptools,
  torch,
  kornia-rs,
}:

buildPythonPackage rec {
  pname = "kornia";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kornia";
    repo = "kornia";
    tag = "v${version}";
    hash = "sha256-jNwqWgmILbSrISepuGZZSUnB9GlgwU5J0zqYwN54ul0=";
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
    changelog = "https://github.com/kornia/kornia/releases/tag/${src.tag}";
    description = "Differentiable computer vision library";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
