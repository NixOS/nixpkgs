{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, cvxopt
, ecos
, multiprocess
, numpy
, osqp
, scipy
, scs
, six
  # Check inputs
, nose
}:

buildPythonPackage rec {
  pname = "cvxpy";
  version = "1.1.4";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f37da2f891508ebc2bbb2b75c46a2076be39a60a45c8a88261e000e8aabeef2";
  };

  propagatedBuildInputs = [
    cvxopt
    ecos
    multiprocess
    numpy
    osqp
    scipy
    scs
    six
  ];

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests cvxpy
  '';

  meta = with lib; {
    description = "A domain-specific language for modeling convex optimization problems in Python.";
    homepage = "https://www.cvxpy.org/";
    downloadPage = "https://github.com/cvxgrp/cvxpy/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
