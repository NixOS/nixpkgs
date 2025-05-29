{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,

  lspSupport ? true,
}:

python3Packages.buildPythonApplication rec {
  pname = "vectorcode";
  version = "0.6.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Davidyz";
    repo = "VectorCode";
    tag = version;
    hash = "sha256-qXrXNt5uI/gePFyJ79y+zksSekq7BzsbL+1tvMQ/zKM=";
  };

  build-system = with python3Packages; [
    pdm-backend
  ];

  dependencies =
    with python3Packages;
    [
      chromadb
      colorlog
      httpx
      json5
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

  postInstall = ''
    $out/bin/vectorcode --print-completion=bash >vectorcode.bash
    $out/bin/vectorcode --print-completion=zsh >vectorcode.zsh
    installShellCompletion vectorcode.{bash,zsh}
  '';

  pythonImportsCheck = [ "vectorcode" ];

  nativeCheckInputs =
    [
      installShellFiles
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
    "test_get_reranker"
    "test_supported_rerankers_initialization"
  ];

  meta = {
    description = "Code repository indexing tool to supercharge your LLM experience";
    homepage = "https://github.com/Davidyz/VectorCode";
    changelog = "https://github.com/Davidyz/VectorCode/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "vectorcode";
  };
}
