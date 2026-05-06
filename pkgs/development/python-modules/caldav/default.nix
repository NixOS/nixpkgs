{
  lib,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  icalendar,
  icalendar-searcher,
  lxml,
  manuel,
  pytestCheckHook,
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

buildPythonPackage rec {
  pname = "caldav";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = "caldav";
    tag = "v${version}";
    hash = "sha256-I31ZUg1N1aX7z50HNDGYo/o17G7+Bdzx4UBK3UsVL/A=";
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
    manuel
    proxy-py
    pyfakefs
    pytest-asyncio
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
