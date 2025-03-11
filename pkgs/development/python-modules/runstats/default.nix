{
  lib,
  setuptools,
  cython,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "runstats";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "grantjenks";
    repo = "python-runstats";
    tag = "v${version}";
    hash = "sha256-YF6S5w/ccWM08nl9inWGbaLKJ8/ivW6c7A9Ny20fldU=";
  };

  build-system = [
    setuptools
    cython
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "runstats" ];

  meta = {
    description = "Python module for computing statistics and regression in a single pass";
    homepage = "https://github.com/grantjenks/python-runstats";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ osbm ];
  };
}
