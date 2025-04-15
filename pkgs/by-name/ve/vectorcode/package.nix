{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,

  lspSupport ? true,
}:

python3Packages.buildPythonApplication rec {
  pname = "vectorcode";
  version = "0.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Davidyz";
    repo = "VectorCode";
    tag = version;
    hash = "sha256-hoANo+CqGvMyFSPDVYVWJUf6UUo3n9C1Yu8xt5yrZUs=";
  };

  build-system = with python3Packages; [
    pdm-backend
  ];

  dependencies =
    with python3Packages;
    [
      chromadb
      httpx
      numpy
      pathspec
      psutil
      pygments
      sentence-transformers
      shtab
      tabulate
      transformers
      tree-sitter
      tree-sitter-language-pack
    ]
    ++ lib.optionals lspSupport optional-dependencies.lsp;

  optional-dependencies = with python3Packages; {
    intel = [
      openvino
      optimum
    ];
    legacy = [
      numpy
      torch
      transformers
    ];
    lsp = [
      lsprotocol
      pygls
    ];
    mcp = [
      mcp
      pydantic
    ];
  };

  pythonImportsCheck = [ "vectorcode" ];

  nativeCheckInputs =
    [
      versionCheckHook
    ]
    ++ (with python3Packages; [
      mcp
      pygls
      pytestCheckHook
    ]);
  versionCheckProgramArg = "version";

  disabledTests = [
    # Require internet access
    "test_get_embedding_function"
    "test_get_embedding_function_fallback"
  ];

  meta = {
    description = "Code repository indexing tool to supercharge your LLM experience";
    homepage = "https://github.com/Davidyz/VectorCode";
    changelog = "https://github.com/Davidyz/VectorCode/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "vectorcode";
  };
}
