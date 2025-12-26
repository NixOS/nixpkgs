{
  lib,
  buildPythonPackage,
  emoji,
  fetchFromGitHub,
  freezegun,
  tzdata,
  pydantic,
  pytest-benchmark,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "ical";
  version = "12.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "ical";
    tag = version;
    hash = "sha256-A3rFZUjUdDkkMhh3ytsBg89o1BtCYWFB0d/usmiuyec=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    tzdata
    pydantic
  ];

  nativeCheckInputs = [
    emoji
    freezegun
    pytest-benchmark
    pytestCheckHook
    syrupy
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "ical" ];

  meta = {
    description = "Library for handling iCalendar";
    homepage = "https://github.com/allenporter/ical";
    changelog = "https://github.com/allenporter/ical/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
