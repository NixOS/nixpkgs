{ stdenv, buildPythonPackage, fetchPypi
, pytest, coverage, virtualenv, pytestcov, six }:

buildPythonPackage rec {
  pname = "pytest-fixture-config";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1717cd7d2233943cae9af419c6e31dca5e40d5de01ef0bcfd5cd06f37548db08";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ coverage virtualenv pytestcov six ];

  checkPhase = ''
    py.test -k "not test_yield_requires_config_doesnt_skip and not test_yield_requires_config_skips"
  '';

  meta = with stdenv.lib; {
    description = "Simple configuration objects for Py.test fixtures. Allows you to skip tests when their required config variables aren’t set.";
    homepage = https://github.com/manahl/pytest-plugins;
    license = licenses.mit;
    maintainers = with maintainers; [ ryansydnor ];
  };
}
