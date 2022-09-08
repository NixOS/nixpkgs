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
  version = "0.9.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Project-MONAI";
    repo = "MONAI";
    rev = version;
    hash = "sha256-GU439svMHY1qIUZ0gM5c5tt6G1hh9eAHYV+38Munw9I=";
  };

  # Ninja is not detected by setuptools for some reason even though it's present:
  postPatch = ''
    substituteInPlace "setup.cfg" --replace "ninja" ""
  '';

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES;
  '';

  nativeBuildInputs = [ ninja which ];
  buildInputs = [ pybind11 ];
  propagatedBuildInputs = [ numpy torch ignite ];

  BUILD_MONAI = 1;

  doCheck = false;  # takes too long; numerous dependencies, some not in Nixpkgs

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
    license = licenses.asl20;
    maintainers = [ maintainers.bcdarwin ];
  };
}
