{
  lib,
  autograd,
  buildPythonPackage,
  fetchFromGitHub,
  future,
  matplotlib,
  numba,
  numpy,
  pytestCheckHook,
  pythonOlder,
  scikit-learn,
  scipy,
  seaborn,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hyppo";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "neurodata";
    repo = "hyppo";
    rev = "refs/tags/v${version}";
    hash = "sha256-bYxqYSOOifQE3gbw8vNk/A13D5TPx7ERSgFvRHMXKGM=";
  };

  # some of the doctests (4/21) are broken, e.g. unbound variables, nondeterministic with insufficient tolerance, etc.
  # (note upstream's .circleci/config.yml only tests test_*.py files despite their pytest.ini adding --doctest-modules)
  postPatch = ''
    substituteInPlace pytest.ini --replace-fail "addopts = --doctest-modules" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    autograd
    future
    numba
    numpy
    scikit-learn
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
    seaborn
  ];
  pytestFlagsArray = [
    "hyppo"
  ];

  meta = with lib; {
    homepage = "https://github.com/neurodata/hyppo";
    description = "Python package for multivariate hypothesis testing";
    changelog = "https://github.com/neurodata/hyppo/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
