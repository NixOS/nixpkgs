{ lib
, buildPythonPackage
, fetchFromGitLab
, numpy
, cvxopt
, python
}:

buildPythonPackage rec {
  pname = "picos";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "picos-api";
    repo = "picos";
    rev = "v${version}";
    sha256 = "018xhc7cb2crkk27lhl63c7h77w5wa37fg41i7nqr4xclr43cs9z";
  };

  propagatedBuildInputs = [
    numpy
    cvxopt
  ];

  checkPhase = ''
    ${python.interpreter} test.py
  '';
  
  meta = with lib; {
    description = "A Python interface to conic optimization solvers";
    homepage = https://gitlab.com/picos-api/picos;
    license = licenses.gpl3;
    maintainers = with maintainers; [ tobiasBora ];
  };
}

