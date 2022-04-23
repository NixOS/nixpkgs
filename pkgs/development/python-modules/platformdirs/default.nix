{ lib
, appdirs
, buildPythonPackage
, fetchPypi
, pytest-mock
, pytestCheckHook
, pythonOlder
, hatchling
, hatch-vcs
}:

buildPythonPackage rec {
  pname = "platformdirs";
  version = "2.5.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WMirsH3LRB5u5LEdjfCshWA4+USrmLe+ayeyo8f+7xk=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  checkInputs = [
    appdirs
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "platformdirs"
  ];

  meta = with lib; {
    description = "Python module for determining appropriate platform-specific directories";
    homepage = "https://platformdirs.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
