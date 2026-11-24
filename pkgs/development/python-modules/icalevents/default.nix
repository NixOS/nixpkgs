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
    owner = "eigenmannmartin";
    repo = "icalevents";
    tag = version;
    hash = "sha256-QDqmcZY/UANVKRjk1ZFEFHgrjtD+hXE4qd3tX64sE7c=";
  };

  postPatch = ''
    # icalendar 7.3 stores unrecognized X- properties as vUnknown, which no
    # longer subclasses vText. The property value is unchanged.
    # https://github.com/collective/icalendar/blob/v7.3.0/src/icalendar/prop/unknown.py
    substituteInPlace test/test_icalevents.py \
      --replace-fail "from icalendar.prop import vText" "from icalendar.prop import vUnknown" \
      --replace-fail 'assertIsInstance(event.component["X-MICROSOFT-CDO-BUSYSTATUS"], vText)' \
      'assertIsInstance(event.component["X-MICROSOFT-CDO-BUSYSTATUS"], vUnknown)'
  '';

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
    changelog = "https://github.com/eigenmannmartin/icalevents/releases/tag/${src.tag}";
    description = "Python module for iCal URL/file parsing and querying";
    homepage = "https://github.com/eigenmannmartin/icalevents";
    maintainers = with lib.maintainers; [ jamiemagee ];
    license = lib.licenses.mit;
  };
}
