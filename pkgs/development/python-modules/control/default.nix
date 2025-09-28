{
  lib,
  buildPythonPackage,
  cvxopt,
  fetchFromGitHub,
  matplotlib,
  numpy,
  numpydoc,
  pytest-timeout,
  pytestCheckHook,
  scipy,
  setuptools-scm,
  setuptools,
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

  nativeCheckInputs = [
    numpydoc
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "control" ];

  disabledTestPaths = [
    # Don't test the docs
    "doc/test_sphinxdocs.py"
  ];

  meta = {
    description = "Python Control Systems Library";
    changelog = "https://github.com/python-control/python-control/releases/tag/${src.tag}";
    homepage = "https://github.com/python-control/python-control";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ Peter3579 ];
  };
}
