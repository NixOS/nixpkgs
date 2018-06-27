{ buildPythonPackage
, fetchPypi
, lib
, pexpect
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-timeout";
  version = "1.3.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08b550b498b9251901a3747f02aa2624ed53a9c8285ca482551346c85b47d641";
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
