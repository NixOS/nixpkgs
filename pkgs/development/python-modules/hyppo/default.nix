{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  autograd,
  future,
  numba,
  numpy,
  pandas,
  patsy,
  scikit-learn,
  scipy,
  statsmodels,

  # tests
  matplotlib,
  pytest-xdist,
  pytestCheckHook,
  seaborn,
}:

buildPythonPackage rec {
  pname = "hyppo";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neurodata";
    repo = "hyppo";
    tag = "v${version}";
    hash = "sha256-7Y+UhneIGwqjsPCnGAQWF/l4r1gFbYs3fdHhV46ZBjA=";
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
    pandas
    patsy
    scikit-learn
    scipy
    statsmodels
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    matplotlib
    seaborn
  ];
  enabledTestPaths = [
    "hyppo"
  ];

  meta = {
    homepage = "https://github.com/neurodata/hyppo";
    description = "Python package for multivariate hypothesis testing";
    changelog = "https://github.com/neurodata/hyppo/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
