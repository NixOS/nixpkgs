{ lib
, buildPythonPackage
, fetchPypi
, cmake
, future
, numpy
, scipy
# check inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "osqp";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "130frig5bznfacqp9jwbshmbqd2xw3ixdspsbkrwsvkdaab7kca7";
  };

  nativeBuildInputs = [ cmake ];
  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    future
    numpy
    scipy
  ];

  pythonImportsCheck = [ "osqp" ];
  checkInputs = [ pytestCheckHook ];
  dontUseSetuptoolsCheck = true;  # don't run checks twice
  disabledTests = [ "mkl_" ];

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
