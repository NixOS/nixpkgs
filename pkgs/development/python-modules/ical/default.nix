{
  lib,
  buildPythonPackage,
  emoji,
  fetchFromGitHub,
  freezegun,
  tzdata,
  pyparsing,
  pydantic,
  pytest-benchmark,
  pytestCheckHook,
  pythonOlder,
  python-dateutil,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "ical";
  version = "10.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "ical";
    tag = version;
    hash = "sha256-vEVhZ7UBftXsB5xq1LhwitV2Gl6kcR5P0ReJ+71SQFY=";
  };

  build-system = [ setuptools ];

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

  pythonImportsCheck = [ "ical" ];

  meta = {
    description = "Library for handling iCalendar";
    homepage = "https://github.com/allenporter/ical";
    changelog = "https://github.com/allenporter/ical/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
