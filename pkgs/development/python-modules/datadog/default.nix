{ lib
, buildPythonPackage
, click
, fetchPypi
, freezegun
, hatchling
, mock
, pytest-vcr
, pytestCheckHook
, python-dateutil
, pythonOlder
, requests
, vcrpy
}:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.44.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BxFw8MfvIlEdv3+b12xL5QDuLT1SBykApch7VJXSxzM=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    click
    freezegun
    mock
    pytestCheckHook
    pytest-vcr
    python-dateutil
    vcrpy
  ];

  disabledTestPaths = [
    "tests/performance"
  ];

  disabledTests = [
    "test_default_settings_set"
  ];

  pythonImportsCheck = [
    "datadog"
  ];

  meta = with lib; {
    description = "The Datadog Python library";
    homepage = "https://github.com/DataDog/datadogpy";
    changelog = "https://github.com/DataDog/datadogpy/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
