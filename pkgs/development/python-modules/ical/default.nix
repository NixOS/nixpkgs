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
  version = "8.0.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "ical";
    rev = "refs/tags/${version}";
    hash = "sha256-nwF6iInQzHdOtmcC1fi6CS2LnYRCxc/DS9bg8IxTlFg=";
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
