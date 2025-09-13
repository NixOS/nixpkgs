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
  version = "0.1.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "grll";
    repo = "mcpadapt";
    tag = "v${version}";
    hash = "sha256-yz4fPywhlCu6DIhYoeaK/eAYjht8LCzx9ltX2XsIFxw=";
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
