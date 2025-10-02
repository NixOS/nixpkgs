{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  autocommand,
  more-itertools,
  beautifulsoup4,
  mechanize,
  keyring,
  requests,
  feedparser,
  icmplib,
  jaraco-text,
  jaraco-logging,
  jaraco-email,
  jaraco-functools,
  jaraco-collections,
  path,
  python-dateutil,
  pathvalidate,
  jsonpickle,
  ifconfig-parser,
  pytestCheckHook,
  cherrypy,
  importlib-resources,
  pyparsing,
  pytest-responses,
  net-tools,
}:

buildPythonPackage rec {
  pname = "jaraco-net";
  version = "10.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.net";
    tag = "v${version}";
    hash = "sha256-yZbiCGUZqJQdV3/vtNLs+B9ZDin2PH0agR4kYvB5HxA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    autocommand
    more-itertools
    beautifulsoup4
    mechanize
    keyring
    requests
    feedparser
    icmplib
    jaraco-text
    jaraco-logging
    jaraco-email
    jaraco-functools
    jaraco-collections
    path
    python-dateutil
    pathvalidate
    jsonpickle
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ ifconfig-parser ];

  pythonImportsCheck = [ "jaraco.net" ];

  nativeCheckInputs = [
    pytestCheckHook
    cherrypy
    importlib-resources
    pyparsing
    pytest-responses
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ net-tools ];

  disabledTestPaths = [
    # require networking
    "jaraco/net/icmp.py"
    "jaraco/net/ntp.py"
    "jaraco/net/scanner.py"
  ];

  meta = {
    changelog = "https://github.com/jaraco/jaraco.net/blob/${src.tag}/NEWS.rst";
    description = "Networking tools by jaraco";
    homepage = "https://github.com/jaraco/jaraco.net";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
