{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  backports-zoneinfo,
  python-dateutil,
  pytz,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "5.0.13";
  pname = "icalendar";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "collective";
    repo = "icalendar";
    rev = "refs/tags/v${version}";
    hash = "sha256-2gpWfLXR4HThw23AWxY2rY9oiK6CF3Qiad8DWHCs4Qk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    pytz
  ] ++ lib.optionals (pythonOlder "3.9") [ backports-zoneinfo ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pytestFlagsArray = [ "src/icalendar" ];

  meta = with lib; {
    changelog = "https://github.com/collective/icalendar/blob/v${version}/CHANGES.rst";
    description = "Parser/generator of iCalendar files";
    mainProgram = "icalendar";
    homepage = "https://github.com/collective/icalendar";
    license = licenses.bsd2;
    maintainers = with maintainers; [ olcai ];
  };
}
