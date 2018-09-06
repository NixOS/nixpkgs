{ buildPythonPackage
, fetchPypi
, lib
, pexpect
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-timeout";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1117fc0536e1638862917efbdc0895e6b62fa61e6cf4f39bb655686af7af9627";
  };
  buildInputs = [ pytest ];
  checkInputs = [ pytest pexpect ];
  checkPhase = ''pytest -ra'';

  meta = with lib;{
    description = "py.test plugin to abort hanging tests";
    homepage = https://bitbucket.org/pytest-dev/pytest-timeout/;
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
