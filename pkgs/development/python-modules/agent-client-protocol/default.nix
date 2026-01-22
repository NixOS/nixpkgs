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

buildPythonPackage rec {
  pname = "agent-client-protocol";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "python-sdk";
    tag = version;
    hash = "sha256-pUOs6TUc0qmY+/AWTtm5kKouHKL8cLMhJ+nZT4r+6sI=";
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

  meta = {
    description = "Python SDK for ACP clients and agents";
    homepage = "https://github.com/agentclientprotocol/python-sdk";
    changelog = "https://github.com/agentclientprotocol/python-sdk/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
