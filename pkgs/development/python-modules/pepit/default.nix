{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cvxpy,
  numpy,
  pandas,
  scipy,
  matplotlib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pepit";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PerformanceEstimation";
    repo = "PEPit";
    rev = version;
    hash = "sha256-Gdymdfi0Iv9KXBNSbAEWGYIQ4k5EONnbyWs+99L5D/A=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cvxpy
    numpy
    pandas
    scipy
    matplotlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "PEPit"
  ];

  meta = {
    description = "Performance Estimation in Python";
    changelog = "https://pepit.readthedocs.io/en/latest/whatsnew/${version}.html";
    homepage = "https://pepit.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
