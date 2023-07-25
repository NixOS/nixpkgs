{ lib
, python-dateutil
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
, pyyaml
}:

buildPythonPackage rec {
  pname = "ical";
  version = "5.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-6xDbr/y9ZNT9thWMLHPi9/EXVXrUdMCVJdQAcd3G2vo=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "tzdata"
  ];

  propagatedBuildInputs = [
    emoji
    python-dateutil
    tzdata
    pydantic
    pyparsing
  ];

  nativeCheckInputs = [
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
