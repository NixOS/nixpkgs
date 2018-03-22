{ buildPythonPackage
, fetchPypi
, lib
, pexpect
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-timeout";
  version = "1.2.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kdp6qbh5v1168l99rba5yfzvy05gmzkmkhldgp36p9xcdjd5dv8";
  };
  buildInputs = [ pytest ];
  checkInputs = [ pytest pexpect ];
  checkPhase = ''pytest -ra'';

  meta = with lib;{
    description = "py.test plugin to abort hanging tests";
    homepage = http://bitbucket.org/pytest-dev/pytest-timeout/;
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
