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
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = "caldav";
    rev = "refs/tags/v${version}";
    hash = "sha256-rixhEIcl37ZIiYFOnJY0Ww75xZy3o/436JcgLmoOGi0=";
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
