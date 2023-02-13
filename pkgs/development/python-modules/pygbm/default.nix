{ lib
, buildPythonPackage
, fetchFromGitHub
, scipy
, numpy
, numba
, scikit-learn
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pygbm";
  version = "0.1.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ogrisel";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qg2md86d0z5aa6jn8kj3rxsippsqsccx1dbraspdsdkycncvww3";
  };

  propagatedBuildInputs = [
    scipy
    numpy
    numba
    scikit-learn
  ];

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    # numerical rounding error in test
    pytest -k "not test_derivatives"
  '';

  meta = with lib; {
    description = "Experimental Gradient Boosting Machines in Python";
    homepage = "https://github.com/ogrisel/pygbm";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
    broken = true;
  };
}
