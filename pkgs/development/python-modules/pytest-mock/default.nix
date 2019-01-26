{ lib, buildPythonPackage, fetchPypi, isPy3k, pytest, mock, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "1.10.0";
 
  src = fetchPypi {
    inherit pname version;
    sha256 = "d89a8209d722b8307b5e351496830d5cc5e192336003a485443ae9adeb7dd4c0";
  };

  propagatedBuildInputs = [ pytest ] ++ lib.optional (!isPy3k) mock;
  nativeBuildInputs = [ setuptools_scm ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Thin-wrapper around the mock package for easier use with py.test.";
    homepage    = https://github.com/pytest-dev/pytest-mock;
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
