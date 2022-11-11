{ lib
, python-dateutil
, buildPythonPackage
, fetchFromGitHub
, freezegun
, tzdata
, pyparsing
, pydantic
, pytest-asyncio
, pytest-benchmark
, pytest-golden
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ical";
  version = "4.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-yPFFOhAscLvhKo7sgXtH1HwcDYq8kWKHzrr3ep857Io=";
  };

  propagatedBuildInputs = [
    python-dateutil
    tzdata
    pydantic
    pyparsing
  ];

  checkInputs = [
    freezegun
    pytest-asyncio
    pytest-benchmark
    pytest-golden
    pytestCheckHook
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
