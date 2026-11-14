{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  setuptools,

  # dependencies
  packaging,

  # optional-dependencies
  gevent,
  h2,
  tornado,
  setproctitle,

  # tests
  inotify,
  pytest-asyncio,
  pytestCheckHook,
  pytest-cov-stub,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "gunicorn";
  version = "27.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "benoitc";
    repo = "gunicorn";
    tag = finalAttrs.version;
    hash = "sha256-ac51uUcXvh3Tur9k4HCwTcwfY+N5dMFVsVRR/V4kmes=";
  };

  build-system = [ setuptools ];

  dependencies = [ packaging ];

  optional-dependencies = {
    gevent = [
      gevent
      packaging
    ];
    tornado = [ tornado ];
    gthread = [ ];
    setproctitle = [ setproctitle ];
    http2 = [ h2 ];
  };

  pythonImportsCheck = [ "gunicorn" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    pytest-cov-stub
    versionCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies
  ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify ];

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
    changelog = "https://github.com/benoitc/gunicorn/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "gunicorn";
  };
})
