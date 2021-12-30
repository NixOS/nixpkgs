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
, cvxopt
}:

buildPythonPackage rec {
  pname = "osqp";
  version = "0.6.2.post4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23831d407c52a67789e0490257f91a62b86ddeaf31dbcdefb7d3801e56596154";
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
  checkInputs = [ pytestCheckHook cvxopt ];
  disabledTests = [
    "mkl_"
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
