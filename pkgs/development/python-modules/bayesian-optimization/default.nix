{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, scikit-learn
, scipy
<<<<<<< HEAD
, colorama
, pytestCheckHook
, pythonOlder
=======
, pytestCheckHook
, isPy27
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "bayesian-optimization";
<<<<<<< HEAD
  version = "1.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bayesian-optimization";
    repo = "BayesianOptimization";
    rev = "refs/tags/v${version}";
    hash = "sha256-Bp/ZhVSW5lTGwnsd/doOXu++Gxw/51owCfMm96Qmgd4=";
=======
  version = "1.2.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "fmfn";
    repo = "BayesianOptimization";
    rev = version;
    sha256 = "01mg9npiqh1qmq5ldnbpjmr8qkiw827msiv3crpkhbj4bdzasbfm";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    scikit-learn
    scipy
<<<<<<< HEAD
    colorama
=======
  ];

  patches = [
    # TypeError with scipy >= 1.8
    # https://github.com/fmfn/BayesianOptimization/issues/300
    (fetchpatch {
      url = "https://github.com/fmfn/BayesianOptimization/commit/b4e09a25842985a4a0acea0c0f5c8789b7be125e.patch";
      hash = "sha256-PfcifCFd4GRNTA+4+T+6A760QAgyZxhDCTyzNn2crdM=";
      name = "scipy_18_fix.patch";
    })
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  pythonImportsCheck = [ "bayes_opt" ];

  meta = with lib; {
    broken = stdenv.isLinux && stdenv.isAarch64;
    description = ''
      A Python implementation of global optimization with gaussian processes
    '';
    homepage = "https://github.com/bayesian-optimization/BayesianOptimization";
    changelog = "https://github.com/bayesian-optimization/BayesianOptimization/releases/tag/v${version}";
=======
  disabledTests = [
    # New sklearn broke one test
    # https://github.com/fmfn/BayesianOptimization/issues/243
    "test_suggest_with_one_observation"
  ];

  pythonImportsCheck = [ "bayes_opt" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = ''
      A Python implementation of global optimization with gaussian processes
    '';
    homepage = "https://github.com/fmfn/BayesianOptimization";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = [ maintainers.juliendehos ];
  };
}
