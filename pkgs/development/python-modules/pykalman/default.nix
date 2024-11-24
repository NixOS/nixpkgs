{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  scipy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pykalman";
  version = "0.9.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pykalman";
    repo = "pykalman";
    rev = "aaf8c8574b0474b6f41b7b135a9a7f2dfbd0e86c"; # no tags
    hash = "sha256-++YqxGMsFGv5OxicDFO9Xz89e62NG8X+6oR6M9ePUcg=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "pykalman" ];

  meta = with lib; {
    description = "Implementation of the Kalman Filter, Kalman Smoother, and EM algorithm in Python";
    homepage = "https://github.com/pykalman/pykalman";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
