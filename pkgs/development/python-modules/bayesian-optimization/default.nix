{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  scikit-learn,
  numpy,
  scipy,
  colorama,

  # tests
  jupyter,
  matplotlib,
  nbconvert,
  nbformat,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bayesian-optimization";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bayesian-optimization";
    repo = "BayesianOptimization";
    rev = "refs/tags/v${version}";
    hash = "sha256-XAO+UeHsOFAmUXqzMY/Iws1E738ZnU4Wz7E4YNIeGKY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    scikit-learn
    numpy
    scipy
    colorama
  ];

  nativeCheckInputs = [
    jupyter
    matplotlib
    nbconvert
    nbformat
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bayes_opt" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python implementation of global optimization with gaussian processes";
    homepage = "https://github.com/bayesian-optimization/BayesianOptimization";
    changelog = "https://github.com/bayesian-optimization/BayesianOptimization/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.juliendehos ];
  };
}
