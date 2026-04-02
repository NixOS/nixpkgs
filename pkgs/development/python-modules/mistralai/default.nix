{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  eval-type-backport,
  httpx,
  jsonpath-python,
  opentelemetry-api,
  opentelemetry-semantic-conventions,
  pydantic,
  python-dateutil,
  typing-inspection,

  # optional-dependencies
  authlib,
  griffe,
  mcp,
  google-auth,
  requests,

  # tests
  opentelemetry-sdk,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mistralai";
  version = "2.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "client-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d6z8l7h8PVPV72Phbb7zPg4pyhxcXA/V5q1Ao+Jtgms=";
  };

  preBuild = ''
    python scripts/prepare_readme.py
  '';

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "opentelemetry-semantic-conventions"
  ];
  dependencies = [
    eval-type-backport
    httpx
    jsonpath-python
    opentelemetry-api
    opentelemetry-semantic-conventions
    pydantic
    python-dateutil
    typing-inspection
  ];

  optional-dependencies = {
    agents = [
      authlib
      griffe
      mcp
    ];
    gcp = [
      google-auth
      requests
    ];
  };

  pythonImportsCheck = [ "mistralai" ];

  nativeCheckInputs = [
    opentelemetry-sdk
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.agents
  ++ finalAttrs.passthru.optional-dependencies.gcp;

  disabledTests = [
    # AssertionError: <Response [200 OK]> is not an instance of <class 'mistralai.extra.observability.otel.TracedResponse'>
    "TestOtelTracing"
  ];

  meta = {
    description = "Python client library for Mistral AI platform";
    homepage = "https://github.com/mistralai/client-python";
    changelog = "https://github.com/mistralai/client-python/blob/${finalAttrs.src.tag}/RELEASES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      mana-byte
    ];
  };
})
