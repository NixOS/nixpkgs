{ lib, buildPythonPackage, fetchPypi, isPy3k, pytest, mock, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "1.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5bf5771b1db93beac965a7347dc81c675ec4090cb841e49d9d34637a25c30568";
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
