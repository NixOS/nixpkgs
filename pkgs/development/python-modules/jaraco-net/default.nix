{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools-scm
, more-itertools
, beautifulsoup4
, mechanize
, keyring
, requests
, feedparser
, jaraco-text
, jaraco-logging
, jaraco-email
, jaraco-functools
, jaraco-collections
, path
, python-dateutil
, pathvalidate
, jsonpickle
, ifconfig-parser
, pytestCheckHook
, cherrypy
, importlib-resources
, pyparsing
, requests-mock
, nettools
}:

buildPythonPackage rec {
  pname = "jaraco-net";
  version = "9.3.1";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.net";
    rev = "refs/tags/v${version}";
    hash = "sha256-aq5v4QlapmMTrqwNA0GtRi/xZCcyoR1giZECBsYwymw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    more-itertools
    beautifulsoup4
    mechanize
    keyring
    requests
    feedparser
    jaraco-text
    jaraco-logging
    jaraco-email
    jaraco-functools
    jaraco-collections
    path
    python-dateutil
    pathvalidate
    jsonpickle
  ] ++ lib.optionals stdenv.isDarwin [
    ifconfig-parser
  ];

  pythonImportsCheck = [ "jaraco.net" ];

  nativeCheckInputs = [
    pytestCheckHook
    cherrypy
    importlib-resources
    pyparsing
    requests-mock
  ] ++ lib.optionals stdenv.isDarwin [
    nettools
  ];

  disabledTestPaths = [
    # doesn't actually contain tests
    "fabfile.py"
    # require networking
    "jaraco/net/ntp.py"
    "jaraco/net/scanner.py"
    "tests/test_cookies.py"
  ];

  # cherrypy does not support Python 3.11
  doCheck = pythonOlder "3.11";

  meta = {
    changelog = "https://github.com/jaraco/jaraco.net/blob/${src.rev}/CHANGES.rst";
    description = "Networking tools by jaraco";
    homepage = "https://github.com/jaraco/jaraco.net";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
