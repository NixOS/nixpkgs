{ lib
, fetchFromGitHub
, buildPythonPackage
, numpy
, scipy
, autograd
, nose2
}:

buildPythonPackage rec {
  pname = "pymanopt";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-dqyduExNgXIbEFlgkckaPfhLFSVLqPgwAOyBUdowwiQ=";
  };

  propagatedBuildInputs = [ numpy scipy ];
  checkInputs = [ nose2 autograd ];

  checkPhase = ''
    # nose2 doesn't properly support excludes
    rm tests/test_{problem,tensorflow,theano}.py

    nose2 tests -v
  '';

  pythonImportsCheck = [ "pymanopt" ];

  meta = {
    description = "Python toolbox for optimization on Riemannian manifolds with support for automatic differentiation";
    homepage = "https://www.pymanopt.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
