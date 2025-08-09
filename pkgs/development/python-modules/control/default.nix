{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  numpy,
  scipy,
  matplotlib,
  setuptools,
  setuptools-scm,
  cvxopt,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "control";
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-control";
    repo = "python-control";
    tag = version;
    hash = "sha256-wLDYPuLnsZ2+cXf7j3BxUbn4IjHPt09LE9cjQGXWrO0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    scipy
    matplotlib
  ];

  optional-dependencies = {
    # slycot is not in nixpkgs
    # slycot = [ slycot ];
    cvxopt = [ cvxopt ];
  };

  pythonImportsCheck = [ "control" ];

  nativeCheckInputs = [
    cvxopt
    pytest-timeout
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/python-control/python-control/releases/tag/${src.tag}";
    description = "Python Control Systems Library";
    homepage = "https://github.com/python-control/python-control";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ Peter3579 ];
  };
}
