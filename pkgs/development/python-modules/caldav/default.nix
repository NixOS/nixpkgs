{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  icalendar,
  lxml,
  pytestCheckHook,
  python,
  recurring-ical-events,
  requests,
  hatchling,
  hatch-vcs,
  proxy-py,
  pyfakefs,
  toPythonModule,
  tzlocal,
  vobject,
  xandikos,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "caldav";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = "caldav";
    tag = "v${version}";
    hash = "sha256-n7ZKTBXg66firbS34J41NrTM/PL/OrKMnS4iguRz4Ho=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    vobject
    lxml
    requests
    icalendar
    recurring-ical-events
  ];

  nativeCheckInputs = [
    proxy-py
    pyfakefs
    pytestCheckHook
    tzlocal
    (toPythonModule (xandikos.override { python3Packages = python.pkgs; }))
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    "tests/test_docs.py"
    "tests/test_examples.py"
  ];

  pythonImportsCheck = [ "caldav" ];

  meta = with lib; {
    description = "CalDAV (RFC4791) client library";
    homepage = "https://github.com/python-caldav/caldav";
    changelog = "https://github.com/python-caldav/caldav/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      marenz
      dotlambda
    ];
  };
}
