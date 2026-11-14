{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-fragments-pdf,
  pymupdf4llm,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-fragments-pdf";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "daturkel";
    repo = "llm-fragments-pdf";
    tag = finalAttrs.version;
    hash = "sha256-hQufPeUY83W/XPk60CLdpi/ijhI9Xw/jxP1BOoCm6ao=";
  };

  patches = [
    # Keep pymupdf's pymupdf_layout recommendation off stdout, where it
    # corrupts the output of every `llm` command once this plugin is loaded.
    ./silence-pymupdf-layout-suggestion.patch
  ];

  postPatch = ''
    # Newer pymupdf4llm renders italics with underscores.
    substituteInPlace tests/test_fragments_reader.py \
      --replace-fail '*This*' '_This_'
  '';

  build-system = [ setuptools ];

  dependencies = [
    llm
    pymupdf4llm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_fragments_pdf" ];

  passthru.tests = llm.mkPluginTest llm-fragments-pdf;

  meta = {
    description = "LLM fragment loader that uses PyMuPDF to insert PDFs as markdown";
    homepage = "https://github.com/daturkel/llm-fragments-pdf";
    changelog = "https://github.com/daturkel/llm-fragments-pdf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
