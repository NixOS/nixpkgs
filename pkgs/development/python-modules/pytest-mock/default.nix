{ lib, buildPythonPackage, fetchPypi, isPy3k, pytest, mock, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "1.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "330bfa1a71c9b6e84e2976f01d70d8a174f755e7f9dc5b22f4b7335992e1e98b";
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
