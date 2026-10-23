{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  pydantic,

  # optional-dependencies
  h2,
  httpx,
  opentelemetry-sdk,
  websockets,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "agent-client-protocol";
  version = "0.12.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "python-sdk";
    tag = finalAttrs.version;
    hash = "sha256-GBMzhDHOiXGQDyHtDEBpGL4SH/I16Zh/QMePhiLHJSE=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    pydantic
  ];

  optional-dependencies = {
    http = [
      h2
      httpx
      websockets
    ];
    logfire = [
      # logfire (unpackaged)
      opentelemetry-sdk
    ];
  };

  pythonImportsCheck = [ "acp" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    uvicorn
  ]
  ++ finalAttrs.passthru.optional-dependencies.http;

  disabledTests = [
    # Agent subprocess cannot complete in the sandbox.
    "test_spawn_agent_process_roundtrip"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python SDK for ACP clients and agents";
    homepage = "https://github.com/agentclientprotocol/python-sdk";
    changelog = "https://github.com/agentclientprotocol/python-sdk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
