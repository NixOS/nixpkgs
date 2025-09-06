{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  poetry-core,

  # dependencies
  docling,
  httpx,
  mcp,
  mellea,
  pydantic,
  pydantic-settings,
  python-dotenv,

  # tests
  pytestCheckHook,
  pytest-asyncio,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "docling-mcp";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-mcp";
    tag = "v${version}";
    hash = "sha256-ktJ5K+1Qb7/lUHPkmv2FMnSe6PiIQ1BvWj5qIG8xfdE=";
  };

  build-system = [
    hatchling
    poetry-core
  ];

  dependencies = [
    docling
    httpx
    (mcp.overridePythonAttrs (old: {
      dependencies = old.dependencies ++ old.optional-dependencies.cli;
    }))
    mellea
    pydantic
    pydantic-settings
    python-dotenv
  ];

  pythonImportsCheck = [
    "docling"
    "docling_mcp"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # error: mcp.shared.exceptions.McpError: Connection closed
    "test_convert_directory_files_into_docling_document"
    "test_list_tools"
    "test_get_tools"
    "test_call_tool"
  ];

  meta = {
    changelog = "https://github.com/docling-project/docling-mcp/blob/${src.tag}/CHANGELOG.md";
    description = "Making docling agentic through MCP";
    homepage = "https://github.com/docling-project/docling-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ codgician ];
  };
}
