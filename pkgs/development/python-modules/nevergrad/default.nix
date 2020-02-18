{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, python
, bayesian-optimization
, cma
, gym 
, matplotlib
, opencv4
, pandas
, pytest
, pytorch
, typing-extensions
}:

buildPythonPackage rec {
  pname = "nevergrad";
  version = "0.3.2";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "nevergrad";
    rev = "v${version}";
    sha256 = "1rbvlm2bivgi1jslnc52mqhpw2bkznh8crk69yfwkkxifcyl1gl9";
  };

  propagatedBuildInputs = [
    bayesian-optimization
    cma
    gym 
    matplotlib
    opencv4
    pandas
    pytorch
    typing-extensions
  ];

  checkInputs = [ pytest ];
  checkPhase = "pytest";

  meta = with lib; {
    description = "A gradient-free optimization platform";
    homepage = "https://github.com/facebookresearch/nevergrad";
    license = licenses.mit;
    maintainers = with maintainers; [ juliendehos ];
  };
}
