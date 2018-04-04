{ stdenv, buildPythonPackage, fetchPypi
, pytest, coverage, virtualenv, pytestcov, six }:

buildPythonPackage rec {
  pname = "pytest-fixture-config";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dpdf36hpkfhgmca4rwmf0vnzz7xqbiw479v11zp12pq4p5w2z3x";
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
