{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
<<<<<<< HEAD
=======
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, packaging
, torch
}:

buildPythonPackage rec {
  pname = "kornia";
<<<<<<< HEAD
  version = "0.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "0.6.12";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-XcQXKn4F3DIgn+XQcN5ZcGZLehd/IPBgLuGzIkPSxZg=";
=======
    hash = "sha256-qLJos1ivEws/jFK4j0Kp1ij9J9ZwCoHFRYXnlYxwPFY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
