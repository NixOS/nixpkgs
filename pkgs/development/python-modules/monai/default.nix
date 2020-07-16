{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, ninja
, ignite
, numpy
, pybind11
, pytorch
, which
}:

buildPythonPackage rec {
  pname = "monai";
  version = "0.8.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Project-MONAI";
    repo = pname;
    rev = version;
    sha256 = "08ji79ygrc90alak4q0nycm8wybkygyq22splagp6m256dmc1jhk";
  };

  # Ninja is not detected by setuptools here for some reason
  patchPhase = ''
    substituteInPlace "setup.cfg" --replace "ninja" ""
  '';

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
  '';

  # note CUDA extensions will not be built if CUDA is not present
  BUILD_MONAI = 1;

  nativeBuildInputs = [ ninja which ];
  buildInputs = [ pybind11 ];
  propagatedBuildInputs = [ ignite numpy pytorch ];

  doCheck = false;  # takes too long, numerous dependencies
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
    description = "Pytorch framework for deep learning in medical imaging";
    homepage = "https://monai.io";
    license = licenses.asl20;
    maintainers = [ maintainers.bcdarwin ];
  };
}
