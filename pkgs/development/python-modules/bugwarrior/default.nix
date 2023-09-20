{ lib, buildPythonPackage, fetchPypi, pythonOlder, setuptools
, twiggy, requests, offtrac, bugzilla, taskw, python-dateutil, pytz, keyring, six
, jinja2, pycurl, dogpile-cache, lockfile, click, pyxdg, future, jira }:

buildPythonPackage rec {
  pname = "bugwarrior";
  version = "1.8.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f024c29d2089b826f05481cace33a62aa984f33e98d226f6e41897e6f11b3f51";
  };

  propagatedBuildInputs = [
    setuptools
    twiggy requests offtrac bugzilla taskw python-dateutil pytz keyring six
    jinja2 pycurl dogpile-cache lockfile click pyxdg future jira
  ];

  # for the moment oauth2client <4.0.0 and megaplan>=1.4 are missing for running the test suite.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ralphbean/bugwarrior";
    description = "Sync github, bitbucket, bugzilla, and trac issues with taskwarrior";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pierron yurrriq ];
  };
}
