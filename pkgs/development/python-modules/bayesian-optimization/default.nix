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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "fmfn";
    repo = "BayesianOptimization";
    rev = "v${version}";
    sha256 = "07sqymg6k5512k7wq4kbp7rsrkb4g90n0ck1f0b9s6glyfpcy4pq";
  };

  propagatedBuildInputs = [
    scikitlearn
    scipy
  ];
  
  checkInputs = [ pytest ];
  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "A Python implementation of global optimization with gaussian processes";
    homepage = "https://github.com/fmfn/BayesianOptimization";
    license = licenses.mit;
    maintainers = [ maintainers.juliendehos ];
  };
}
