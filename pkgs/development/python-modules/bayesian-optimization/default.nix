{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, scikit-learn
, scipy
, pytest
, isPy27
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

  checkInputs = [ pytest ];
  checkPhase = ''
    # New sklearn broke one test: https://github.com/fmfn/BayesianOptimization/issues/243
    pytest tests -k "not test_suggest_with_one_observation"
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "A Python implementation of global optimization with gaussian processes";
    homepage = "https://github.com/fmfn/BayesianOptimization";
    license = licenses.mit;
    maintainers = [ maintainers.juliendehos ];
  };
}
