{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  autograd,
  numba,
  numpy,
  scikit-learn,
  scipy,
  matplotlib,
  seaborn,
}:

buildPythonPackage rec {
  pname = "hyppo";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "neurodata";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-QRE3oSxTEobTQ/7DzCAUOdjzIZmWUn9bgPmJWj6JuZg=";
  };

  # some of the doctests (4/21) are broken, e.g. unbound variables, nondeterministic with insufficient tolerance, etc.
  # (note upstream's .circleci/config.yml only tests test_*.py files despite their pytest.ini adding --doctest-modules)
  postPatch = ''
    substituteInPlace pytest.ini --replace-fail "addopts = --doctest-modules" ""
  '';

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    autograd
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
