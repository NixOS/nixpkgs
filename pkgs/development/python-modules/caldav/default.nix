{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  icalendar,
  lxml,
  pytestCheckHook,
  pythonOlder,
  python,
  recurring-ical-events,
  requests,
  setuptools,
  setuptools-scm,
  toPythonModule,
  tzlocal,
  vobject,
  xandikos,
}:

buildPythonPackage rec {
  pname = "caldav";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = "caldav";
    tag = "v${version}";
    hash = "sha256-SYjfQG4muuBcnVeu9cl00Zb2fGUhw157LLxA5/N5EJ0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    vobject
    lxml
    requests
    icalendar
    recurring-ical-events
  ];

  nativeCheckInputs = [
    pytestCheckHook
    tzlocal
    (toPythonModule (xandikos.override { python3Packages = python.pkgs; }))
  ];

  pythonImportsCheck = [ "caldav" ];

  meta = with lib; {
    description = "CalDAV (RFC4791) client library";
    homepage = "https://github.com/python-caldav/caldav";
    changelog = "https://github.com/python-caldav/caldav/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      marenz
      dotlambda
    ];
  };
}
