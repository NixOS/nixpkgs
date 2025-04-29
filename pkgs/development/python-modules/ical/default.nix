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
  version = "9.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "ical";
    tag = version;
    hash = "sha256-E5CIvjWi18E8PYuOsXhsQempa2pPw1frSWK+/R3UqmQ=";
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
