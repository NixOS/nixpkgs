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
, pythonAtLeast
, pythonOlder
, requests
, vcrpy
}:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.45.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a//tZ0SMtL9d/1WfsqzuHAbn2oYSuOKnNPJ4tQs5ZgM=";
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
  ] ++ lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/DataDog/datadogpy/issues/746
    "TestDogshell"
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
