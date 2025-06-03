{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  mpmath,
  numpy,
  scipy,

  # tests
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "hankel";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "steven-murray";
    repo = "hankel";
    tag = "v${version}";
    hash = "sha256-/5PvbH8zz2siLS1YJYRSrl/Cpi0WToBu1TJhlek8VEE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    mpmath
    numpy
    scipy
  ];

  pythonImportsCheck = [ "hankel" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  disabledTests = [
    # ValueError: Calling nonzero on 0d arrays is not allowed.
    "test_nu0"
  ];

  meta = {
    description = "Implementation of Ogata's (2005) method for Hankel transforms";
    homepage = "https://github.com/steven-murray/hankel";
    changelog = "https://github.com/steven-murray/hankel/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
