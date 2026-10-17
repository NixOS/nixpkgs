{
  lib,
  fetchFromGitHub,
  fetchurl,
  python3Packages,
  versionCheckHook,
  stdenv,
}:

let
  # tiktoken lazily downloads the cl100k_base encoding on first use; pre-seed its
  # cache so the test suite is hermetic (the build sandbox has no network).
  cl100kCacheKey = "9b5ad71b2ce5302211f9c61530b329a4922fc6a4";
  tiktokenCl100k = fetchurl {
    url = "https://openaipublic.blob.core.windows.net/encodings/cl100k_base.tiktoken";
    hash = "sha256-Ijkht27pm96ZW3/3OFE+7xAPtR0YyTWXoRO8/+hlsqc=";
  };
in
python3Packages.buildPythonApplication (finalAttrs: {
  # We use PyPI name here to avoid conflict with the `zotero-mcp` package
  pname = "zotero-mcp-server";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "54yyyu";
    repo = "zotero-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zTZ40MxZGkmxL5WzALogJ9828rz5fHkTAyDdcLfpva8=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    bibtexparser
    fastmcp
    markitdown
    mcp
    pydantic
    python-dotenv
    pyzotero
    requests
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
  __darwinAllowLocalNetworking = true;

  # semantic + pdf extras are needed at check time: chroma_client raises
  # ImportError without chromadb, and several test modules import
  # zotero_mcp.semantic_search unguarded. Mirrors upstream [dev] = [all].
  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
    chromadb
    google-genai
    openai
    sentence-transformers
    tiktoken
    ebooklib
    pymupdf
  ];
  doCheck = true;

  # Keep the suite hermetic under the build sandbox: give pytest a writable HOME
  # (the default /homeless-shelter is read-only) and point tiktoken at the cache.
  preCheck = ''
    export HOME=$(mktemp -d)
    export TIKTOKEN_CACHE_DIR=$(mktemp -d)
    ln -s ${tiktokenCl100k} "$TIKTOKEN_CACHE_DIR"/${cl100kCacheKey}
  '';

  # Exercises a real PDF download (it deliberately bypasses the SSRF guard).
  disabledTests = [ "test_cascade_order" ];

  pythonImportsCheck = [ "zotero_mcp" ];

  __structuredAttrs = true;

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
