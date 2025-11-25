{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  icalendar,
  lxml,
  manuel,
  pytestCheckHook,
  python,
  radicale,
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
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = "caldav";
    tag = "v${version}";
    hash = "sha256-iVM3dBG2CNaMOUlEM0nGVKYUZHfX0LKjars7HJ1QWC0=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    lxml
    requests
    icalendar
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
