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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "fmfn";
    repo = "BayesianOptimization";
    rev = "v${version}";
    sha256 = "0ylip9xdi0cjzmdayxxpazdfaa9dl0sdcl2qsfn3p0cipj59bdvd";
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
