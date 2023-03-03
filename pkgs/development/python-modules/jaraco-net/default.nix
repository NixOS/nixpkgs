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
, jaraco_text
, jaraco_logging
, jaraco-email
, jaraco_functools
, jaraco_collections
, path
, python-dateutil
, pathvalidate
, jsonpickle
, ifconfig-parser
, pytestCheckHook
, cherrypy
, importlib-resources
, requests-mock
}:

buildPythonPackage rec {
  pname = "jaraco-net";
  version = "9.3.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.net";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ks8e3xPjIWgSO0PSpjMYftxAuDt3ilogoDFuJqfN74o=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    more-itertools
    beautifulsoup4
    mechanize
    keyring
    requests
    feedparser
    jaraco_text
    jaraco_logging
    jaraco-email
    jaraco_functools
    jaraco_collections
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
    requests-mock
  ];

  disabledTestPaths = [
    # doesn't actually contain tests
    "fabfile.py"
    # require networking
    "jaraco/net/ntp.py"
    "jaraco/net/scanner.py"
    "tests/test_cookies.py"
  ];

  meta = {
    changelog = "https://github.com/jaraco/jaraco.net/blob/${src.rev}/CHANGES.rst";
    description = "Networking tools by jaraco";
    homepage = "https://github.com/jaraco/jaraco.net";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
