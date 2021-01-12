{ lib
, buildPythonPackage
, fetchPypi
, cmake
, future
, numpy
, qdldl
, scipy
# check inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "osqp";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "262162039f6ad6c9ffee658541b18cfae8240b65edbde71d9b9e3af42fbfe4b3";
  };

  nativeBuildInputs = [ cmake ];
  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    future
    numpy
    qdldl
    scipy
  ];

  pythonImportsCheck = [ "osqp" ];
  checkInputs = [ pytestCheckHook ];
  disabledTests = [
    "mkl_"
  ];
    pytestFlagsArray = [
    # These cannot collect b/c of circular dependency on cvxpy: https://github.com/oxfordcontrol/osqp-python/issues/50
    "--ignore=module/tests/basic_test.py"
    "--ignore=module/tests/feasibility_test.py"
    "--ignore=module/tests/polishing_test.py"
    "--ignore=module/tests/unconstrained_test.py"
    "--ignore=module/tests/update_matrices_test.py"
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
