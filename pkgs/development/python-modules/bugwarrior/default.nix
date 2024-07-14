{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  twiggy,
  requests,
  offtrac,
  bugzilla,
  taskw,
  python-dateutil,
  pytz,
  keyring,
  six,
  jinja2,
  pycurl,
  dogpile-cache,
  lockfile,
  click,
  pyxdg,
  future,
  jira,
}:

buildPythonPackage rec {
  pname = "bugwarrior";
  version = "1.8.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8CTCnSCJuCbwVIHKzjOmKqmE8z6Y0ib25BiX5vEbP1E=";
  };

  propagatedBuildInputs = [
    setuptools
    twiggy
    requests
    offtrac
    bugzilla
    taskw
    python-dateutil
    pytz
    keyring
    six
    jinja2
    pycurl
    dogpile-cache
    lockfile
    click
    pyxdg
    future
    jira
  ];

  # for the moment oauth2client <4.0.0 and megaplan>=1.4 are missing for running the test suite.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/GothenburgBitFactory/bugwarrior";
    description = "Sync github, bitbucket, bugzilla, and trac issues with taskwarrior";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pierron ];
  };
}
