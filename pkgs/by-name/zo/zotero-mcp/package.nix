{
  lib,
  fetchFromGitHub,
  fetchurl,
  python3Packages,
  versionCheckHook,
  stdenv,
  withSemantic ? true,
  withPdf ? true,
  withScite ? true,
}:

let
  # tiktoken lazily downloads the cl100k_base encoding on first use; pre-seed its
  # cache so the test suite is hermetic (the build sandbox has no network).
  cl100kCacheKey = "9b5ad71b2ce5302211f9c61530b329a4922fc6a4";
  tiktokenCl100k = fetchurl {
    url = "https://openaipublic.blob.core.windows.net/encodings/cl100k_base.tiktoken";
    hash = "sha256-Ijkht27pm96ZW3/3OFE+7xAPtR0YyTWXoRO8/+hlsqc=";
    meta.license = lib.licenses.mit;
  };
in
python3Packages.buildPythonApplication (finalAttrs: {
  # We use PyPI name here to avoid conflict with the `zotero-mcp` package
  pname = "zotero-mcp-server";
  version = "0.12.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "54yyyu";
    repo = "zotero-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H/CH1FsBhucmtQRD9qpYGmG+/flhiBmV8WLLRxFPoLw=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies =
    (with python3Packages; [
      bibtexparser
      fastmcp
      httpx
      markdownify
      pdf-inspector
      pydantic
      python-dotenv
      pyzotero
      requests
      unidecode
    ])
    ++ lib.optionals withSemantic finalAttrs.passthru.optional-dependencies.semantic
    ++ lib.optionals withPdf finalAttrs.passthru.optional-dependencies.pdf
    ++ lib.optionals withScite finalAttrs.passthru.optional-dependencies.scite;

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

  # We use pytestFlags because `disabledTests` cannot parse `[publisher PDF]` bits
  pytestFlags = [
    # Exercises a real PDF download (it deliberately bypasses the SSRF guard).
    "--deselect=tests/test_pdf_cascade.py::TestTryAttachOaPdf::test_cascade_order"
    # The SSRF guard resolves example.com before the mocked requests.get is reached.
    "--deselect=tests/test_user_agent.py::TestEveryWiredClientIdentifiesItselfTheSameWay::test_sends_the_shared_constant[publisher PDF]"
    "--deselect=tests/test_user_agent.py::TestEveryWiredClientIdentifiesItselfTheSameWay::test_does_not_pose_as_a_browser[publisher PDF]"
    # Asserts on an error message that depends on the local Zotero install; upstream skips it on CI.
    "--deselect=tests/test_webdav.py::test_download_attachment_file_falls_back_to_webdav"
  ];

  pythonImportsCheck = [ "zotero_mcp" ];

  __structuredAttrs = true;

  meta = {
    description = "Model Context Protocol server for Zotero";
    homepage = "https://github.com/54yyyu/zotero-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      t4ccer
      yzx9
    ];
    platforms = with lib.platforms; linux ++ darwin;
    # Error: terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
    broken = with stdenv.hostPlatform; (isLinux && isAarch64) || (isDarwin && isx86_64);
    mainProgram = "zotero-mcp";
  };
})
