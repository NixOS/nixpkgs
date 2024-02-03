{ lib
, buildPythonPackage
, cmake
, cvxopt
, fetchPypi
, future
, numpy
, pytestCheckHook
, pythonOlder
, qdldl
, scipy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "osqp";
  version = "0.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A+Rg5oPsLOD4OTU936PEyP+lCauM9qKyr7tYb6RT4YA=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    setuptools-scm
  ];

  propagatedBuildInputs = [
    future
    numpy
    qdldl
    scipy
  ];

  nativeCheckInputs = [
    cvxopt
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "osqp"
  ];

  disabledTests = [
    # Need an unfree license package - mkl
    "test_issue14"
  ];

  meta = with lib; {
    description = "The Operator Splitting QP Solver";
    longDescription = ''
      Numerical optimization package for solving problems in the form
        minimize        0.5 x' P x + q' x
        subject to      l <= A x <= u

      where x in R^n is the optimization variable
    '';
    homepage = "https://osqp.org/";
    downloadPage = "https://github.com/oxfordcontrol/osqp-python/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
