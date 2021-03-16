{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, cvxopt
, ecos
, numpy
, osqp
, scipy
, scs
  # Check inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cvxpy";
  version = "1.1.11";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W4qly+g07Q1iYJ76/tGZNkBPa+oavhTDUYRQ3cZ+s1I=";
  };

  propagatedBuildInputs = [
    cvxopt
    ecos
    numpy
    osqp
    scipy
    scs
  ];

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "./cvxpy" ];
  # Disable the slowest benchmarking tests, cuts test time in half
  disabledTests = [
    "test_tv_inpainting"
    "test_diffcp_sdp_example"
  ];

  meta = with lib; {
    description = "A domain-specific language for modeling convex optimization problems in Python";
    homepage = "https://www.cvxpy.org/";
    downloadPage = "https://github.com/cvxgrp/cvxpy/releases";
    changelog = "https://github.com/cvxgrp/cvxpy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
