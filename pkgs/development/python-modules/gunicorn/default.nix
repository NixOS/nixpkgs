{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  packaging,

  # optional-dependencies
  eventlet,
  gevent,
  tornado,
  setproctitle,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "26.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "benoitc";
    repo = "gunicorn";
    tag = version;
    hash = "sha256-F1zjgh5iCmy3LExWhs0tWRjiqloHEUlD4IqVp7U+ht4=";
  };

  build-system = [ setuptools ];

  dependencies = [ packaging ];

  optional-dependencies = {
    gevent = [ gevent ];
    eventlet = [ eventlet ];
    tornado = [ tornado ];
    gthread = [ ];
    setproctitle = [ setproctitle ];
  };

  pythonImportsCheck = [ "gunicorn" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    pytest-cov-stub
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = [
    # failure while starting a gunicorn instance
    "TestSignalHandlingIntegration"
  ];

  disabledTestPaths = [
    # tries to start gunicorn and fails on import
    "tests/test_control_socket_integration.py"
  ];

  meta = {
    description = "WSGI HTTP Server for UNIX, fast clients and sleepy applications";
    homepage = "https://github.com/benoitc/gunicorn";
    changelog = "https://github.com/benoitc/gunicorn/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "gunicorn";
  };
}
