{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, packaging
, torch
}:

buildPythonPackage rec {
  pname = "kornia";
  version = "0.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-XcQXKn4F3DIgn+XQcN5ZcGZLehd/IPBgLuGzIkPSxZg=";
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
    changelog = "https://github.com/kornia/kornia/releases/tag/v${version}";
    description = "Differentiable computer vision library";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
