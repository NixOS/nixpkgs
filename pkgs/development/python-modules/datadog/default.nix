{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, hatchling
, decorator
, requests
, typing ? null
, configparser
, click
, freezegun
, mock
, pytestCheckHook
, pytest-vcr
, python-dateutil
, vcrpy
}:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.44.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BxFw8MfvIlEdv3+b12xL5QDuLT1SBykApch7VJXSxzM=";
  };

  postPatch = ''
    find . -name '*.pyc' -exec rm {} \;
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [ decorator requests ]
    ++ lib.optional (pythonOlder "3.5") typing
    ++ lib.optional (pythonOlder "3.0") configparser;

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

  pythonImportsCheck = [ "datadog" ];

  meta = with lib; {
    description = "The Datadog Python library";
    homepage = "https://github.com/DataDog/datadogpy";
    changelog = "https://github.com/DataDog/datadogpy/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
