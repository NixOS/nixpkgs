{ lib
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, matplotlib
, pytest
, isPy3k
}:

buildPythonPackage rec {
  version = "1.4.5";
  pname = "filterpy";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "4f2a4d39e4ea601b9ab42b2db08b5918a9538c168cff1c6895ae26646f3d73b1";
  };

  nativeCheckInputs = [ pytest ];
  propagatedBuildInputs = [ numpy scipy matplotlib ];

  # single test fails (even on master branch of repository)
  # project does not use CI
  checkPhase = ''
    pytest --ignore=filterpy/common/tests/test_discretization.py
  '';

  meta = with lib; {
    homepage = "https://github.com/rlabbe/filterpy";
    description = "Kalman filtering and optimal estimation library";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
