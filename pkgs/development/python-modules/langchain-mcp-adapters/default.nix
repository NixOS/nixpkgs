{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  langchain-core,
  mcp,
  typing-extensions,
  dirty-equals,
  langchain,
  python,
  pytest-asyncio,
  pytest-socket,
  pytest-timeout,
  pytestCheckHook,
  websockets,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain-mcp-adapters";
  version = "0.3.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-mcp-adapters";
    tag = "langchain-mcp-adapters==${finalAttrs.version}";
    hash = "sha256-9MNVqju1Mhpwg80/RdknvRHgKa7GdAtwa2FIrlKXdEU=";
  };

  postPatch = ''
    # 2 seconds is insufficient for subprocess startup sometimes
    substituteInPlace tests/utils.py tests/conftest.py \
      --replace-fail 'max_attempts = 20' 'max_attempts = 300'
  '';

  build-system = [ pdm-backend ];

  dependencies = [
    langchain-core
    mcp
    typing-extensions
  ];

  nativeCheckInputs = [
    dirty-equals
    langchain
    pytest-asyncio
    pytest-socket
    pytest-timeout
    pytestCheckHook
    websockets
  ];

  preCheck = ''
    # the stdio launcher omits PYTHONPATH and in nix it causes problems because
    # it is used to expose python deps. so provide python with the mcp sdk on
    # PATH so it can be imported
    export PATH="${lib.makeBinPath [ (python.withPackages (_: [ mcp ])) ]}:$PATH"
  '';

  pythonImportsCheck = [ "langchain_mcp_adapters" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=langchain-mcp-adapters==(.*)" ];
  };

  meta = {
    description = "Make Anthropic Model Context Protocol (MCP) tools compatible with LangChain and LangGraph agents";
    homepage = "https://github.com/langchain-ai/langchain-mcp-adapters";
    changelog = "https://github.com/langchain-ai/langchain-mcp-adapters/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaravrav ];
  };
})
