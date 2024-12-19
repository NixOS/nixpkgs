{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  networkx,
  scipy,
  scikit-learn,
  torch,
  apricot-select,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pomegranate";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmschrei";
    repo = "pomegranate";
    tag = "v${version}";
    hash = "sha256-p2Gn0FXnsAHvRUeAqx4M1KH0+XvDl3fmUZZ7MiMvPSs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    networkx
    scipy
    scikit-learn
    torch
    apricot-select
  ];

  pythonImportsCheck = [
    "pomegranate"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/"
  ];

  disabledTestPaths = [
    "tests/distributions/test_categorical.py" # Arrays are not almost equal to 6 decimals
    "tests/distributions/test_independent_component.py" # Arrays are not almost equal to 3 decimals
    "tests/distributions/test_joint_categorical.py" # Arrays are not almost equal to 3 decimals
    "tests/test_bayesian_network.py" # Arrays are not equal
    "tests/test_gmm.py" # Arrays are not almost equal to 3 decimals
    "tests/test_markov_chain.py" # Arrays are not almost equal to 6 decimals
  ];

  meta = {
    changelog = "https://github.com/jmschrei/pomegranate/releases/tag/${src.tag}";
    description = "Probabilistic and graphical models for Python, implemented in cython for speed";
    homepage = "https://github.com/jmschrei/pomegranate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rybern ];
  };
}
