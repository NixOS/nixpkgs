{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
}:

buildPythonPackage rec {
  pname = "agent-client-protocol-python-sdk";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "python-sdk";
    rev = version;
    hash = "sha256-w9WH4sdHvDsiwzkVdKy9SROzFZwLCC8SUJVI8TLOKaY=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    pydantic
  ];

  optional-dependencies = {
    # logfire = [
    #   logfire
    #   opentelemetry-sdk
    # ];
  };

  pythonImportsCheck = [ "acp" ];

  meta = {
    description = "Python SDK for ACP clients and agents";
    homepage = "https://github.com/agentclientprotocol/python-sdk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jinser ];
  };
}
