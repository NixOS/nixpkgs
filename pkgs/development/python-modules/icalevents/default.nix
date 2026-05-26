{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  poetry-core,
  icalendar,
  pook,
  python-dateutil,
  pytz,
  urllib3,
}:

buildPythonPackage rec {
  pname = "icalevents";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "icalevents";
    tag = version;
    hash = "sha256-QDqmcZY/UANVKRjk1ZFEFHgrjtD+hXE4qd3tX64sE7c=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    icalendar
    python-dateutil
    pytz
    urllib3
  ];

  nativeCheckInputs = [
    pook
    pytestCheckHook
  ];

  disabledTests = [
    # Makes HTTP calls
    "test_events_url"
    "test_events_async_url"
  ];

  pythonImportsCheck = [ "icalevents" ];

  meta = {
    changelog = "https://github.com/jazzband/icalevents/releases/tag/${src.tag}";
    description = "Python module for iCal URL/file parsing and querying";
    homepage = "https://github.com/jazzband/icalevents";
    maintainers = with lib.maintainers; [ jamiemagee ];
    license = lib.licenses.mit;
  };
}
