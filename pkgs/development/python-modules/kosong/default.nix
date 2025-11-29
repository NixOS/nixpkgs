{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,

  anthropic,
  python-dotenv,
  loguru,
  openai,
  pydantic,
  jsonschema,
}:

buildPythonPackage {
  pname = "kosong";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MoonshotAI";
    repo = "kosong";
    tag = "0.22.0";
    hash = "sha256-pGNciRe8Fbt100esc2mPI5tFfkWB7UnlwODVBSlt9+c=";
  };

  build-system = [ uv-build ];
  pythonRelaxDeps = true;

  dependencies = [
    anthropic
    python-dotenv
    loguru
    openai
    pydantic
    jsonschema
  ];

  pythonImportsCheck = [ "kosong" ];

  meta = {
    description = "Streaming-first LLM-abstraction layer designed for modern agentic applications";
    homepage = "https://github.com/MoonshotAI/kosong";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jinser ];
  };
}
