{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, twiggy
, requests
, offtrac
, bugzilla
, taskw
, python-dateutil
, pytz
, keyring
, six
, jinja2
, pycurl
, dogpile-cache
, lockfile
, click
, pyxdg
, future
, jira
, pytestCheckHook
, responses
, megaplan
}:

buildPythonPackage rec {
  pname = "bugwarrior";
  version = "1.8.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f024c29d2089b826f05481cace33a62aa984f33e98d226f6e41897e6f11b3f51";
  };

  propagatedBuildInputs = [
    bugzilla
    click
    dogpile-cache
    future
    jinja2
    jira
    keyring
    lockfile
    offtrac
    pycurl
    python-dateutil
    pytz
    pyxdg
    requests
    setuptools
    six
    taskw
    twiggy
  ];

  checkInputs = [
    megaplan
    pytestCheckHook
    responses
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  meta = with lib; {
    homepage = "https://github.com/ralphbean/bugwarrior";
    description = "Sync github, bitbucket, bugzilla, and trac issues with taskwarrior";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pierron yurrriq ];
  };
}
