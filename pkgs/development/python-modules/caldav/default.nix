{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  icalendar,
  lxml,
  manuel,
  requests,
  proxy-py,
  pyfakefs,
  pytestCheckHook,
  pythonOlder,
  python,
  radicale,
  recurring-ical-events,
  toPythonModule,
  tzlocal,
  vobject,
  writableTmpDirAsHomeHook,
  xandikos,
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
    hatch-vcs
    hatchling
  ];

  dependencies = [
    icalendar
    lxml
    requests
    recurring-ical-events
  ];

  nativeCheckInputs = [
    manuel
    proxy-py
    pyfakefs
    pytestCheckHook
    (toPythonModule (radicale.override { python3 = python; }))
    tzlocal
    vobject
    writableTmpDirAsHomeHook
    (toPythonModule (xandikos.override { python3Packages = python.pkgs; }))
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "caldav" ];

  meta = {
    description = "CalDAV (RFC4791) client library";
    homepage = "https://github.com/python-caldav/caldav";
    changelog = "https://github.com/python-caldav/caldav/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      marenz
      dotlambda
    ];
  };
}
