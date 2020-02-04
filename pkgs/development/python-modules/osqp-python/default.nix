{ lib, buildPythonPackage, fetchPypi, cmake, future, numpy, python, pytest, scipy }:

buildPythonPackage rec {
  pname = "osqp";
  version = "0.6.1";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "47b17996526d6ecdf35cfaead6e3e05d34bc2ad48bcb743153cefe555ecc0e8c";
  };
  
  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ future numpy scipy ];
  dontUseCmakeConfigure = true;
  
  # deselect mkl_pardiso_tests: raises WorkspaceAllocationError in setup
  patchPhase = ''
    substituteInPlace module/tests/mkl_pardiso_test.py --replace \
      "class mkl_pardiso_tests(unittest.TestCase):" \
      "@unittest.skip('raises WorkspaceAllocationError')
    class mkl_pardiso_tests(unittest.TestCase):"
  '';
  
  checkInputs = [ pytest ];
  
  checkPhase = ''
    pytest module/tests -k 'not mkl_paradiso_tests'
  '';
  
  meta = with lib; {
    description = "Python wrapper for OSQP, the Operator Splitting QP Solver";
    homepage = "https://github.com/oxfordcontrol/osqp-python";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
