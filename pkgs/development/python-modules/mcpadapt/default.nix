{
  lib,
  buildPythonPackage,
  crewai,
  fetchFromGitHub,
  hatchling,
  jsonref,
  langchain,
  langchain-anthropic,
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

buildPythonPackage (finalAttrs: {
  pname = "mcpadapt";
  version = "0.1.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "grll";
    repo = "mcpadapt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mUwGKr+QBkqMKhfEEIlF/jZDW7enKYdngNIoxG5hMU4=";
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
    crewai = [ crewai ];
    langchain = [
      langchain
      langchain-anthropic
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
    changelog = "https://github.com/grll/mcpadapt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
