{ buildPythonPackage
, fetchPypi
, lib
, pexpect
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-timeout";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b261bec5782b603c98b4bb803484bc96bf1cdcb5480dae0999d21c7e0423a23";
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
