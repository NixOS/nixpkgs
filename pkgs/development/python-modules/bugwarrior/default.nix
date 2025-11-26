{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  requests,
  offtrac,
  python-bugzilla,
  taskw,
  python-dateutil,
  pytz,
  keyring,
  jinja2,
  dogpile-cache,
  lockfile,
  click,
  jira,
  pydantic,
  tomli,
}:

buildPythonPackage rec {
  pname = "bugwarrior";
  version = "2.0.0";
  disabled = pythonOlder "3.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-blTKtNfhTZyJHwIOq1P7HjtEmNnz/bL6dWr402veNm4=";
  };

  propagatedBuildInputs = [
    setuptools

    click
    dogpile-cache
    jinja2
    lockfile
    pydantic
    python-dateutil
    pytz
    requests
    taskw
    tomli

    python-bugzilla
    keyring
    jira
    offtrac
  ];

  # for the moment oauth2client <4.0.0 is missing for running the test suite.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/GothenburgBitFactory/bugwarrior";
    description = "Sync github, bitbucket, bugzilla, and trac issues with taskwarrior";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [
      pierron
      ryneeverett
    ];
  };
}
