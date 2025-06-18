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
  version = "2.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bayesian-optimization";
    repo = "BayesianOptimization";
    tag = "v${version}";
    hash = "sha256-F1+M5znfI7lHGJRRTgmQxrLTYZmLc90Q0TCvpRoSVTU=";
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
    changelog = "https://github.com/bayesian-optimization/BayesianOptimization/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.juliendehos ];
  };
}
