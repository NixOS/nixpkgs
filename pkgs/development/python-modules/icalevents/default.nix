{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pythonOlder,
  pytestCheckHook,
  poetry-core,
  httplib2,
  icalendar,
  python-dateutil,
  pytz,
}:

buildPythonPackage rec {
  pname = "icalevents";
  version = "0.1.29";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "icalevents";
    rev = "refs/tags/v${version}";
    hash = "sha256-Bp+Wz88q65Gem8LyRz0A4xE5hIgOD+iZ7E1UlnfFiD4=";
  };

  patches = [
    (fetchpatch2 {
      name = "icalendar-v6-compat.patch";
      url = "https://github.com/jazzband/icalevents/commit/fa925430bd63e46b0941b84a1ae2c9a063f2f720.patch";
      hash = "sha256-MeRC3iJ5raKvl9udzv/44Vs34LxSzq1S6VVKAVFSpiY=";
    })
  ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    httplib2
    icalendar
    python-dateutil
    pytz
  ];

  pythonRelaxDeps = [
    "httplib2"
    "icalendar"
    "pytz"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

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
