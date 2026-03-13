{
  lib,
  buildPythonPackage,
  kimi-cli,
  uv-build,
  jsonschema,
  loguru,
  openai,
  pydantic,
  python-dotenv,
  typing-extensions,
  mcp,
  anthropic,
  google-genai,
}:

let
  inherit (kimi-cli) version src;
in
buildPythonPackage (finalAttrs: {
  pname = "kosong";
  inherit version;
  src = src + /packages/kosong;
  pyproject = true;

  build-system = [ uv-build ];
  pythonRelaxDeps = true;

  dependencies = [
    jsonschema
    loguru
    openai
    pydantic
    python-dotenv
    typing-extensions
    mcp
  ]
  ++ finalAttrs.passthru.optional-dependencies.contrib;
  optional-dependencies = {
    contrib = [
      anthropic
      google-genai
    ];
  };

  meta = {
    description = "Streaming-first LLM-abstraction layer designed for modern agentic applications";
    homepage = "https://github.com/MoonshotAI/kimi-cli/tree/main/packages/kosong";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jinser ];
  };
})
