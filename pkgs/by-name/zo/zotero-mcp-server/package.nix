{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
  stdenv,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  # We use PyPI name here to avoid conflict with the `zotero-mcp` package
  pname = "zotero-mcp-server";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "54yyyu";
    repo = "zotero-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GZkzABsUh6qua66K4URPq0InLgs6cqLgKEXm7wzT+s8=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    fastmcp
    markitdown
    mcp
    pydantic
    python-dotenv
    pyzotero
    unidecode
  ];

  optional-dependencies = with python3Packages; {
    semantic = [
      chromadb
      google-genai
      openai
      sentence-transformers
      tiktoken
    ];
    pdf = [
      ebooklib
      pymupdf
    ];
    scite = [
      requests
    ];
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  # Tests call @mcp.tool()-decorated functions directly (e.g. server.advanced_search(...))
  # but fastmcp>=2.14 wraps them as FunctionTool objects, causing:
  #   TypeError: 'FunctionTool' object is not callable
  # Affects 202/372 tests in v0.2.2 — disable check phase entirely.
  doCheck = false;
  nativeCheckInputs =
    (with python3Packages; [
      pytestCheckHook
    ])
    ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "zotero_mcp" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Model Context Protocol server for Zotero";
    homepage = "https://github.com/54yyyu/zotero-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      yzx9
    ];
    platforms = with lib.platforms; linux ++ darwin;
    # Error: terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
    broken = with stdenv.hostPlatform; (isLinux && isAarch64) || (isDarwin && isx86_64);
    mainProgram = "zotero-mcp";
  };
})
