{ lib, buildPythonPackage, fetchPypi, isPy3k, pytest, mock, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "1.7.1";
 
  src = fetchPypi {
    inherit pname version;
    sha256 = "0jgr1h1f0m9dl3alxiiw55as28pj2lpihz12gird9z1i3vvdyydq";
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
