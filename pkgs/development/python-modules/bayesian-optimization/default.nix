{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  scikit-learn,
  scipy,
  colorama,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bayesian-optimization";
  version = "1.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bayesian-optimization";
    repo = "BayesianOptimization";
    rev = "refs/tags/v${version}";
    hash = "sha256-Bp/ZhVSW5lTGwnsd/doOXu++Gxw/51owCfMm96Qmgd4=";
  };

  propagatedBuildInputs = [
    scikit-learn
    scipy
    colorama
  ];

  nativeCheckInputs = [ pytestCheckHook ];

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
