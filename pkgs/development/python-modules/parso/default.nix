{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.8.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8519430ad07087d4c997fda3a7918f7cfa27cb58972a8c89c2a0295a1c940e9e";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A Python Parser";
    homepage = "https://parso.readthedocs.io/en/latest/";
    changelog = "https://github.com/davidhalter/parso/blob/master/CHANGELOG.rst";
    license = licenses.mit;
  };
}
