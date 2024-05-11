{ lib
, buildPythonPackage
, emoji
, fetchFromGitHub
, freezegun
, tzdata
, pyparsing
, pydantic
, pytest-benchmark
, pytestCheckHook
, pythonOlder
, python-dateutil
, setuptools
, syrupy
}:

buildPythonPackage rec {
  pname = "ical";
  version = "8.0.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "ical";
    rev = "refs/tags/${version}";
    hash = "sha256-GA2Kn6OednhQtNzmIq5npN2qXVaMHCzy02Jwx7g3GBA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    python-dateutil
    tzdata
    pydantic
    pyparsing
  ];

  nativeCheckInputs = [
    emoji
    freezegun
    pytest-benchmark
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [
    "ical"
  ];

  meta = with lib; {
    description = "Library for handling iCalendar";
    homepage = "https://github.com/allenporter/ical";
    changelog = "https://github.com/allenporter/ical/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
