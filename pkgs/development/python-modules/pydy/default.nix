{ lib
, buildPythonPackage
, fetchPypi
, nose
, cython
, numpy
, scipy
, sympy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pydy";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-e/Ssfd5llioA7ccLULlRdHR113IbR4AJ4/HmzQuU7vI=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    sympy
  ];

  checkInputs = [
    nose
    cython
    pytestCheckHook
  ];

  disabledTests = [
    # Tests not fixed yet. Check https://github.com/pydy/pydy/issues/465
    "test_generate_cse"
    "test_generate_code_blocks"
    "test_doprint"
    "test_OctaveMatrixGenerator"
  ];

  meta = with lib; {
    description = "Python tool kit for multi-body dynamics";
    homepage = "http://pydy.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
