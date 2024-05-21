{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, python-dateutil
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "freezegun";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EJObC6D/Wtrs87BqXC9zBx2WeOUHxertsjx2HVasd0s=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "freezegun"
  ];

  meta = with lib; {
    description = "Library that allows your Python tests to travel through time";
    homepage = "https://github.com/spulec/freezegun";
    changelog = "https://github.com/spulec/freezegun/blob/${version}/CHANGELOG";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
