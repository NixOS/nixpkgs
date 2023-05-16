{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, ninja
, ignite
, numpy
, pybind11
, torch
, which
}:

buildPythonPackage rec {
  pname = "monai";
<<<<<<< HEAD
  version = "1.2.0";
  disabled = pythonOlder "3.8";
=======
  version = "1.1.0";
  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Project-MONAI";
    repo = "MONAI";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-nMxROOBkLPmw1GRKiZq6WGJq93LOpSg/7zIVOg+WzC8=";
=======
    hash = "sha256-XTjZhynIiFtFjJSW6rRAnpErZvf6QHkuK4e2L6l3naM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Ninja is not detected by setuptools for some reason even though it's present:
  postPatch = ''
    substituteInPlace "setup.cfg" --replace "    ninja" ""
  '';

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES;
  '';

  nativeBuildInputs = [ ninja which ];
  buildInputs = [ pybind11 ];
  propagatedBuildInputs = [ numpy torch ignite ];

  BUILD_MONAI = 1;

<<<<<<< HEAD
  doCheck = false;  # takes too long; tries to download data
=======
  doCheck = false;  # takes too long; numerous dependencies, some not in Nixpkgs
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    changelog = "https://github.com/Project-MONAI/MONAI/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = [ maintainers.bcdarwin ];
  };
}
