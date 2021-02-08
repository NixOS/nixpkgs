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
  version = "1.1.10";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ecd0a8b89f799cea254928dea8792d9c69c37db0bd830b4cda629b2b2be52270";
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
