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
  version = "0.48.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1NZhNYw+f4Afv+FRGPXM8Iub2bH0W4uRBgWWUoPtrWQ=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    requests
  ];

  __darwinAllowLocalNetworking = true;

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
    # https://github.com/DataDog/datadogpy/issues/800
    "tests/integration/api/test_*.py"
  ];

  disabledTests = [
    "test_default_settings_set"
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
