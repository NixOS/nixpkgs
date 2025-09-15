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
  version = "0.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-control";
    repo = "python-control";
    tag = version;
    hash = "sha256-E9RZDUK01hzjutq83XdLr3d97NwjmQzt65hqVg2TBGE=";
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
