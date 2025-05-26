{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,

  setuptools,
  setuptools-scm,
  pyyaml,
  aiohttp,
  iso8601,
  python-json-logger,
  clickclick,
  typing-extensions,

  pytest-mock,
  pytest-timeout,
  pytest-asyncio,
  pyngrok,
  freezegun,
  certvalidator,
  aresponses,
}:

buildPythonPackage rec {
  pname = "kopf";
  version = "1.37.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nolar";
    repo = "kopf";
    tag = version;
    hash = "sha256-FwQnt5UoK+Qx7suFACwEtTIvBneJQ19/WmdelWmf+Z0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyyaml
    python-json-logger
    aiohttp
    iso8601
    clickclick
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyngrok
    pytest-timeout
    pytest-asyncio
    pytest-mock
    freezegun
    certvalidator
    aresponses
  ];

  disabledTestPaths = [
    # Module astpath unavailable in nixpkgs
    "tests/admission/test_certificates.py"
    "tests/e2e/test_examples.py"

    #Module certbuilder unavailable in nixpkgs
    "tests/admission/test_webhook_detection.py"
    "tests/admission/test_webhook_ngrok.py"
    "tests/admission/test_webhook_server.py"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "kopf"
  ];

  meta = {
    description = "Python framework to write Kubernetes operators";
    homepage = "https://kopf.readthedocs.io/";
    changelog = "https://github.com/nolar/kopf/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
  };
}
