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
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = "caldav";
    tag = "v${version}";
    hash = "sha256-FsIF4BcwAUyYw8J7o4j4CnSd8eIc1Yd5WtxErC6RZ7Y=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    dnspython
    lxml
    requests
    icalendar
    icalendar-searcher
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

  disabledTests = [
    # test contacts CalDAV servers on the internet
    "test_rfc8764_test_conf"
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
