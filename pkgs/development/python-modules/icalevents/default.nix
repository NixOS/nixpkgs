{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "icalevents";
    tag = "v${version}";
    hash = "sha256-xIio+zJtIa0mM7aHFHm1QW36hww82h4A1YWaWUCxx14=";
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

  meta = with lib; {
    changelog = "https://github.com/jazzband/icalevents/releases/tag/v${version}";
    description = "Python module for iCal URL/file parsing and querying";
    homepage = "https://github.com/jazzband/icalevents";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.mit;
  };
}
