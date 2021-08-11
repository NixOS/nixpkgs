{ lib
, fetchFromGitHub
, buildPythonPackage
, numpy
, scipy
, autograd
, nose2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pymanopt";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0zk775v281375sangc5qkwrkb8yc9wx1g8b1917s4s8wszzkp8k6";
  };

  propagatedBuildInputs = [ numpy scipy ];
  checkInputs = [ nose2 autograd pytestCheckHook ];

  disabledTestPaths = [
    "tests/test_problem.py"
    "tests/test_tensorflow.py"
    "tests/test_theano.py"
  ];

  pythonImportsCheck = [ "pymanopt" ];

  meta = {
    description = "Python toolbox for optimization on Riemannian manifolds with support for automatic differentiation";
    homepage = "https://www.pymanopt.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
