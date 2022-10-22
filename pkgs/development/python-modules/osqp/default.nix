{ lib
, buildPythonPackage
, fetchPypi
, cmake
, future
, numpy
, qdldl
, setuptools-scm
, scipy
# check inputs
, pytestCheckHook
, cvxopt
}:

buildPythonPackage rec {
  pname = "osqp";
  version = "0.6.2.post5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2fa17aae42a7ed498ec261b33f262bb4b3605e7e8464062159d9fae817f0d61";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [ cmake setuptools-scm ];
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
