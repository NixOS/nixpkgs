{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  pydantic,

  # optional-dependencies
  opentelemetry-sdk,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "agent-client-protocol";
  version = "0.12.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "python-sdk";
    tag = finalAttrs.version;
    hash = "sha256-IJJ4zgwkLP7CnU330X1K6p/We3A+tm/Veu64C2XhPS8=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    pydantic
  ];

  optional-dependencies = {
    logfire = [
      # logfire (unpackaged)
      opentelemetry-sdk
    ];
  };

  pythonImportsCheck = [ "acp" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Hangs forever
    "test_spawn_agent_process_roundtrip"
  ];

  disabledTestPaths = [
    # Optional HTTP transport dependencies are not packaged here.
    "tests/http"
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
