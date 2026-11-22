{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-mcp-client,
  mcp,
  pytest-asyncio,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-mcp-client";
  version = "0.1a0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-mcp-client";
    tag = finalAttrs.version;
    hash = "sha256-XEWx3olxtwlk9wVRH7bwuXCqfrZxkk8NIrd919Q9Mes=";
  };

  build-system = [ setuptools ];

  dependencies = [
    llm
    mcp
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_mcp_client" ];

  passthru.tests = llm.mkPluginTest llm-mcp-client;

  meta = {
    description = "Access tools from MCP servers as LLM tools";
    homepage = "https://github.com/simonw/llm-mcp-client";
    changelog = "https://github.com/simonw/llm-mcp-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
