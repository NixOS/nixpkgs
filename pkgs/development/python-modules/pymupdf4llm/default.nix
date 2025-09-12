{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pymupdf,
}:

buildPythonPackage rec {
  pname = "pymupdf4llm";
  version = "0.0.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymupdf";
    repo = "RAG";
    tag = "v${version}";
    hash = "sha256-rezdDsjNCDetvrX3uvykYuL/y40MZnr0fFMvQY3JRr0=";
  };

  sourceRoot = "${src.name}/pymupdf4llm";

  build-system = [ setuptools ];

  dependencies = [ pymupdf ];

  checkPhase = ''
    runHook preCheck

    python3 - <<'EOF'
    import fitz
    import pymupdf4llm

    doc = fitz.open()
    page = doc.new_page()
    page.insert_text((72, 72), "Hello, Nix!")
    doc.save("input.pdf")

    md = pymupdf4llm.to_markdown("input.pdf")
    assert isinstance(md, str), "Returned value is not a string"
    assert "Hello, Nix!" in md, "Returned value does not contain the expected text"
    EOF

    runHook postCheck
  '';

  pythonImportsCheck = [ "pymupdf4llm" ];

  meta = {
    description = "PyMuPDF Utilities for LLM/RAG - converts PDF pages to Markdown format for Retrieval-Augmented Generation";
    homepage = "https://github.com/pymupdf/RAG";
    changelog = "https://github.com/pymupdf/RAG/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ryota2357 ];
  };
}
