{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  packaging,
  torch,
  kornia-rs,
}:

buildPythonPackage rec {
  pname = "kornia";
  version = "0.7.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-iEg27b2JVLtAYLFncaSqIh5FyvmmitKAKP7Tl0WWNdk=";
  };

  propagatedBuildInputs = [
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

  meta = with lib; {
    homepage = "https://kornia.github.io/kornia";
    changelog = "https://github.com/kornia/kornia/releases/tag/v${version}";
    description = "Differentiable computer vision library";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
