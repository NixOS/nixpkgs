{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  poetry-core,

  # dependencies
  beautifulsoup4,
  certifi,
  deepsearch-glm,
  docling-core,
  docling-ibm-models,
  docling-parse,
  easyocr,
  filetype,
  huggingface-hub,
  lxml,
  marko,
  # ocrmac # not yet packaged
  onnxruntime,
  openpyxl,
  pandas,
  pillow,
  pyarrow,
  pydantic,
  pydantic-settings,
  pypdfium2,
  python-docx,
  python-pptx,
  rapidocr-onnxruntime,
  requests,
  rtree,
  scipy,
  tesserocr,
  typer,

  # optional dependencies
  # mkdocs-click # not yet packaged
  mkdocs-jupyter,
  mkdocs-material,
  mkdocstrings,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "docling";
  version = "2.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DS4SD";
    repo = "docling";
    tag = "v${version}";
    hash = "sha256-ySywKaLxjtgQM7RtzJrxZDS3z8uMwAwPDYO51uKHT28=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    beautifulsoup4
    certifi
    deepsearch-glm
    docling-core
    docling-ibm-models
    docling-parse
    easyocr
    filetype
    huggingface-hub
    lxml
    marko
    # ocrmac # not yet packaged
    onnxruntime
    openpyxl
    pandas
    pillow
    pyarrow
    pydantic
    pydantic-settings
    pypdfium2
    python-docx
    python-pptx
    rapidocr-onnxruntime
    requests
    rtree
    scipy
    tesserocr
    typer
  ];

  pythonRelaxDeps = [
    "pillow"
    "typer"
  ];

  optional-dependencies = {
    ocrmac = [
      # ocrmac # not yet packaged
    ];
    rapidocr = [
      onnxruntime
      rapidocr-onnxruntime
    ];
    tesserocr = [
      tesserocr
    ];

    docs = [
      # mkdocs-click # not yet packaged
      mkdocs-jupyter
      mkdocs-material
      mkdocstrings
      # griffle-pydantic
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "docling"
  ];

  disabledTests = [
    "test_e2e_pdfs_conversions" # AssertionError: ## TableFormer: Table Structure Understanding with Transf
    "test_e2e_conversions" # RuntimeError: Tesseract is not available

    # huggingface_hub.errors.LocalEntryNotFoundError: An error happened
    "test_cli_convert"
    "test_code_and_formula_conversion"
    "test_picture_classifier"
    "test_convert_path"
    "test_convert_stream"
    "test_compare_legacy_output"
    "test_ocr_coverage_threshold"

    # requires network access
    "test_page_range"

    # AssertionError: pred_itxt==true_itxt
    "test_e2e_valid_csv_conversions"
  ];

  meta = {
    description = "Get your documents ready for gen AI";
    homepage = "https://github.com/DS4SD/docling";
    changelog = "https://github.com/DS4SD/docling/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "docling";
  };
}
