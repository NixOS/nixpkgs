{ lib
, python-dateutil
, buildPythonPackage
, emoji
, fetchFromGitHub
, freezegun
, tzdata
, py
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
  version = "4.2.9";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-p1cvs+xLin2WK2zyqQFd1vWKzt+LU2mpDSieOgA7Qf8=";
  };

  propagatedBuildInputs = [
    emoji
    python-dateutil
    tzdata
    pydantic
    pyparsing
  ];

  nativeCheckInputs = [
    freezegun
    py
    pytest-asyncio
    pytest-benchmark
    pytest-golden
    pytestCheckHook
  ];

  # https://github.com/allenporter/ical/issues/136
  disabledTests = [ "test_all_zoneinfo" ];

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
