{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcache, pep8 }:

buildPythonPackage rec {
  pname = "pytest-pep8";
  version = "1.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06032agzhw1i9d9qlhfblnl3dw5hcyxhagn7b120zhrszbjzfbh3";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ pytestcache pep8 ];

  checkPhase = ''
    py.test
  '';

  # Fails
  doCheck = false;

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = https://pypi.python.org/pypi/pytest-pep8;
    description = "pytest plugin to check PEP8 requirements";
  };
}
