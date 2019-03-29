{ lib, buildPythonPackage, fetchPypi, isPy3k, pytest, mock, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "1.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbec53e7cb0f2b57275220cb4f2822093ac89e486095555105ffe1a4e2f11df4";
  };

  propagatedBuildInputs = lib.optional (!isPy3k) mock;
  nativeBuildInputs = [ setuptools_scm pytest ];

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
