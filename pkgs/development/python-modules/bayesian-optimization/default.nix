{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  scikit-learn,
  numpy,
  scipy,
  colorama,
  jupyter,
  matplotlib,
  nbconvert,
  nbformat,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bayesian-optimization";
  version = "1.5.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bayesian-optimization";
    repo = "BayesianOptimization";
    rev = "refs/tags/v${version}";
    hash = "sha256-pDgvdQhlJ5aMRGdi2qXRXVCdJRvrOP/Nr0SSZyHH1WM=";
  };

  build-system = [ poetry-core ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    broken = stdenv.isLinux && stdenv.isAarch64;
    description = ''
      A Python implementation of global optimization with gaussian processes
    '';
    homepage = "https://github.com/bayesian-optimization/BayesianOptimization";
    changelog = "https://github.com/bayesian-optimization/BayesianOptimization/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.juliendehos ];
  };
}
