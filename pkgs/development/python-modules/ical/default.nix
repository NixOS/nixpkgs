{
  lib,
  buildPythonPackage,
  emoji,
  fetchFromGitHub,
  freezegun,
  tzdata,
  pdoc,
  pydantic,
  pytest-benchmark,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "ical";
  version = "14.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "ical";
    tag = finalAttrs.version;
    hash = "sha256-y+YKHSVPd1Lkkjty2xA1O4YKmXvE4c0yIASEhjV82xo=";
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
    pdoc
    pytest-benchmark
    pytestCheckHook
    syrupy
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "ical" ];

  meta = {
    description = "Library for handling iCalendar";
    homepage = "https://github.com/allenporter/ical";
    changelog = "https://github.com/allenporter/ical/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
