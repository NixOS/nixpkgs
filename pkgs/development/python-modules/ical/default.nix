{ lib
, buildPythonPackage
, emoji
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
, pythonRelaxDepsHook
, python-dateutil
, pyyaml
, setuptools
}:

buildPythonPackage rec {
  pname = "ical";
  version = "6.1.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-pFmJYXIhc9jhpc9ZjSNaol5h5Jb8ZvxuQsQL/2Rjryc=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  pythonRelaxDeps = [
    "tzdata"
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
    pytest-asyncio
    pytest-benchmark
    pytest-golden
    pytestCheckHook
    pyyaml
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
