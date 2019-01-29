{ buildPythonPackage
, fetchPypi
, fetchpatch
, lib
, pexpect
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-timeout";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cczcjhw4xx5sjkhxlhc5c1bkr7x6fcyx12wrnvwfckshdvblc2a";
  };

  checkInputs = [ pytest pexpect ];
  checkPhase = ''pytest -ra'';

  meta = with lib;{
    description = "py.test plugin to abort hanging tests";
    homepage = https://bitbucket.org/pytest-dev/pytest-timeout/;
    license = licenses.mit;
    maintainers = with maintainers; [ makefu costrouc ];
  };
}
