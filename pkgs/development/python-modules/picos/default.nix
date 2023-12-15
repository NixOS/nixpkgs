{ lib
, buildPythonPackage
, fetchFromGitLab
, numpy
, cvxopt
, python
, networkx
}:

buildPythonPackage rec {
  pname = "picos";
  version = "2.0";
  format = "setuptools";

  src = fetchFromGitLab {
    owner = "picos-api";
    repo = "picos";
    rev = "v${version}";
    sha256 = "1k65iq791k5r08gh2kc6iz0xw1wyzqik19j6iam8ip732r7jm607";
  };

  # Needed only for the tests
  nativeCheckInputs = [
    networkx
  ];

  propagatedBuildInputs = [
    numpy
    cvxopt
  ];

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  meta = with lib; {
    description = "A Python interface to conic optimization solvers";
    homepage = "https://gitlab.com/picos-api/picos";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tobiasBora ];
  };
}
