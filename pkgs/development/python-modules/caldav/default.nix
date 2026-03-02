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
  version = "2.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = "caldav";
    tag = "v${version}";
    hash = "sha256-xtxWDlYESIwkow/YdjaUAkJ/x2jdUyhqfSRycJVLncY=";
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
    pytestCheckHook
    (toPythonModule (radicale.override { python3 = python; }))
    tzlocal
    vobject
    writableTmpDirAsHomeHook
    (toPythonModule (xandikos.override { python3Packages = python.pkgs; }))
  ];

  disabledTests = [
    # test contacts CalDAV servers on the internet
    "test_rfc8764_test_conf"
  ];

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
