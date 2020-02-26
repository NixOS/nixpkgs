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
  version = "1.0.25";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04zalvc8lckjfzm3i2ir32ib5pd6v7hxqqcnsnq6fw40vffm4dc5";
  };

  propagatedBuildInputs = [
    cvxopt
    ecos
    multiprocess
    osqp
    scs
    six
  ];

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests
  '';

  meta = {
    description = "A domain-specific language for modeling convex optimization problems in Python.";
    homepage = "https://www.cvxpy.org/";
    downloadPage = "https://github.com/cvxgrp/cvxpy/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drewrisinger ];
  };
}
