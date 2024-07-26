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
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SJhDl7O1jvXfxkXWowSwBg9hK87P2q9Fzor/AHemy2o=";
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
