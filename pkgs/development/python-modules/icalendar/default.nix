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
  version = "5.0.12";
  pname = "icalendar";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "collective";
    repo = "icalendar";
    rev = "refs/tags/v${version}";
    hash = "sha256-313NcknY2zad4lI+/P0szDVjEQ8VatnSiBiaG/Ta1Bw=";
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
