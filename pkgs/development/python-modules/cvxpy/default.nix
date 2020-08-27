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
, pytestCheckHook
, nose
}:

buildPythonPackage rec {
  pname = "cvxpy";
  version = "1.1.5";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c826a874db2e4cefe54e63ebd3a3763d0d72e55a17c7d1cfec80008a87b8d81";
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

  checkInputs = [ pytestCheckHook nose ];
  pytestFlagsArray = [ "./cvxpy" ];
  # Disable the slowest benchmarking tests, cuts test time in half
  disabledTests = [
    "test_tv_inpainting"
    "test_diffcp_sdp_example"
  ];

  meta = with lib; {
    description = "A domain-specific language for modeling convex optimization problems in Python.";
    homepage = "https://www.cvxpy.org/";
    downloadPage = "https://github.com/cvxgrp/cvxpy/releases";
    changelog = "https://github.com/cvxgrp/cvxpy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
