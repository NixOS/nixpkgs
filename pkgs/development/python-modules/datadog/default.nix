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
<<<<<<< HEAD
  version = "0.47.0";
=======
  version = "0.45.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-R747LD1wmn9bcJ6xJu1P5sx5d9YY/lwVjdicKp99mRY=";
=======
    hash = "sha256-a//tZ0SMtL9d/1WfsqzuHAbn2oYSuOKnNPJ4tQs5ZgM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    requests
  ];

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
