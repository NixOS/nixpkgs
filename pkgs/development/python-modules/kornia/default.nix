{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, packaging
, torch
}:

buildPythonPackage rec {
  pname = "kornia";
  version = "0.6.11";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-APqITIt2P+16qp27dwLoAq9vY5CYpd49IWfYHTcZTSI=";
  };

  propagatedBuildInputs = [
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
    "kornia.testing"
    "kornia.utils"
  ];

  doCheck = false;  # tests hang with no single test clearly responsible

  meta = with lib; {
    homepage = "https://kornia.github.io/kornia";
    description = "Differentiable computer vision library";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
