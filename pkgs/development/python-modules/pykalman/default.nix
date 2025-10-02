{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  scipy,
  scikit-base,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pykalman";
  version = "0.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pykalman";
    repo = "pykalman";
    tag = "v${version}";
    hash = "sha256-SMK0b2twlHk4sbNfwWafqDYXlhrZhgpaC1nhv2XQaqo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    scikit-base
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
