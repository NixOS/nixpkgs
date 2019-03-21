{ lib, buildPythonPackage, fetchPypi, isPy3k, pytest, mock, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d0d06d173eecf172703219a71dbd4ade0e13904e6bbce1ce660e2e0dc78b5c4";
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
