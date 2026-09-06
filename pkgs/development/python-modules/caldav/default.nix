{
  lib,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  httpx,
  icalendar,
  icalendar-searcher,
  lxml,
  manuel,
  pytest9_0CheckHook,
  python,
  radicale,
  recurring-ical-events,
  niquests,
  hatchling,
  hatch-vcs,
  proxy-py,
  pyfakefs,
  pytest-asyncio,
  python-dateutil,
  pyyaml,
  toPythonModule,
  tzlocal,
  vobject,
  xandikos,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "caldav";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = "caldav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FV1C8RlbkNXOTtRKSCNgiGetImW0+647JgmZtf5U+pY=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    dnspython
    lxml
    niquests
    icalendar
    icalendar-searcher
    recurring-ical-events
    python-dateutil
    pyyaml
  ];

  nativeCheckInputs = [
    httpx
    manuel
    proxy-py
    pyfakefs
    pytest-asyncio
    pytest9_0CheckHook
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
    changelog = "https://github.com/python-caldav/caldav/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      marenz
      dotlambda
    ];
  };
})
