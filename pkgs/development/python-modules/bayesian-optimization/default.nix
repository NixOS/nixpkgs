{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, scikitlearn
, scipy
, pytest
}:

buildPythonPackage rec {
  pname = "bayesian-optimization";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "fmfn";
    repo = "BayesianOptimization";
    rev = version;
    sha256 = "01mg9npiqh1qmq5ldnbpjmr8qkiw827msiv3crpkhbj4bdzasbfm";
  };

  propagatedBuildInputs = [
    scikitlearn
    scipy
  ];

  checkInputs = [ pytest ];
  checkPhase = ''
    # New sklearn broke one test: https://github.com/fmfn/BayesianOptimization/issues/243
    pytest tests -k "not test_suggest_with_one_observation"
  '';

  meta = with lib; {
    description = "A Python implementation of global optimization with gaussian processes";
    homepage = "https://github.com/fmfn/BayesianOptimization";
    license = licenses.mit;
    maintainers = [ maintainers.juliendehos ];
  };
}
