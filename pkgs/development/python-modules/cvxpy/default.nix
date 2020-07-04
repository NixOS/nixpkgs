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
  version = "1.1.1";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b8e90af9c0046394a73144ef1b93f1f69df1ba00779bb3d607add006179ba9d9";
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
