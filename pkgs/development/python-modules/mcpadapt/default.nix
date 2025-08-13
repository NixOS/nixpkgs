{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jsonref,
  langchain,
  langgraph,
  llama-index,
  mcp,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  smolagents,
  soundfile,
  torchaudio,
}:

buildPythonPackage rec {
  pname = "mcpadapt";
  version = "0.1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "grll";
    repo = "mcpadapt";
    tag = "v${version}";
    hash = "sha256-mU/zcNEHmPfSMEMgjj4u0iwmXBH2cJzGEANPxyiR1l0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    jsonref
    mcp
    python-dotenv
  ];

  optional-dependencies = {
    audio = [
      torchaudio
      soundfile
    ];
    # crewai = [ crewai ];
    langchain = [
      langchain
      # langchain-anthropic
      langgraph
    ];
    llamaindex = [ llama-index ];
    smolagents = [ smolagents ];
  };

  pythonImportsCheck = [ "mcpadapt" ];

  # Circular dependency smolagents
  doCheck = false;

  meta = {
    description = "MCP servers tool";
    homepage = "https://github.com/grll/mcpadapt";
    changelog = "https://github.com/grll/mcpadapt/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
