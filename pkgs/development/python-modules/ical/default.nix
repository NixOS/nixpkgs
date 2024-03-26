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
  version = "7.0.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "ical";
    rev = "refs/tags/${version}";
    hash = "sha256-RiwWnRSe0HdeGVo592A+Rk+IvA1Lfp6mY+/ZEyqJBDU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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
