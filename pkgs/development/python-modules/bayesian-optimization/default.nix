{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, scikit-learn
, scipy
, pytestCheckHook
, isPy27
, fetchpatch
}:

buildPythonPackage rec {
  pname = "bayesian-optimization";
  version = "1.2.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "fmfn";
    repo = "BayesianOptimization";
    rev = version;
    sha256 = "01mg9npiqh1qmq5ldnbpjmr8qkiw827msiv3crpkhbj4bdzasbfm";
  };

  propagatedBuildInputs = [
    scikit-learn
    scipy
  ];

  patches = [
    # TypeError with scipy >= 1.8
    # https://github.com/fmfn/BayesianOptimization/issues/300
    (fetchpatch {
      url = "https://github.com/fmfn/BayesianOptimization/commit/b4e09a25842985a4a0acea0c0f5c8789b7be125e.patch";
      hash = "sha256-PfcifCFd4GRNTA+4+T+6A760QAgyZxhDCTyzNn2crdM=";
      name = "scipy_18_fix.patch";
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

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
    license = licenses.mit;
    maintainers = [ maintainers.juliendehos ];
  };
}
