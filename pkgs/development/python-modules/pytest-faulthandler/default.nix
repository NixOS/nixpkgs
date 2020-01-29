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
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed72bbce87ac344da81eb7d882196a457d4a1026a3da4a57154dacd85cd71ae5";
  };

  nativeBuildInputs = [ setuptools_scm pytest ];
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
