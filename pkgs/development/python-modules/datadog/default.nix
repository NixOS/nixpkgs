{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  freezegun,
  hatchling,
  mock,
  pytest-vcr,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  requests,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.50.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F3JXdL8rsKSPHQltknB0ksGH8krgiWCvCwwvqXlY/VE=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ requests ];

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

  pythonImportsCheck = [ "datadog" ];

  meta = with lib; {
    description = "Datadog Python library";
    homepage = "https://github.com/DataDog/datadogpy";
    changelog = "https://github.com/DataDog/datadogpy/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
