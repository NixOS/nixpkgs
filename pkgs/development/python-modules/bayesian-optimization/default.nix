{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  scikit-learn,
  numpy,
  scipy,
  colorama,
  packaging,

  # tests
  jupyter,
  matplotlib,
  nbconvert,
  nbformat,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bayesian-optimization";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bayesian-optimization";
    repo = "BayesianOptimization";
    tag = "v${version}";
    hash = "sha256-CYkFobGLlh5cPLwChRWXCow0d5uz8eN5hcRanNMfW8s=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.7.21,<0.8.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    scikit-learn
    numpy
    scipy
    colorama
    packaging
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
