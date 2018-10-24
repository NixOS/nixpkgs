{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
, pytest-mock
, pythonOlder
, faulthandler
}:

buildPythonPackage rec {
  pname = "pytest-faulthandler";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf8634c3fd6309ef786ec03b913a5366163fdb094ebcfdebc35626400d790e0d";
  };

  buildInputs = [ setuptools_scm pytest ];
  checkInputs = [ pytest-mock ];
  propagatedBuildInputs = lib.optional (pythonOlder "3.0") faulthandler;

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Py.test plugin that activates the fault handler module for tests";
    homepage = https://github.com/pytest-dev/pytest-faulthandler;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
