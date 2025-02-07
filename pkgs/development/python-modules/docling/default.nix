{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # dependencies
  pydantic,
  docling-core,
  docling-ibm-models,
  deepsearch-glm,
  docling-parse,
  filetype,
  pypdfium2,
  pydantic-settings,
  huggingface-hub,
  requests,
  easyocr,
  tesserocr,
  certifi,
  rtree,
  scipy,
  typer,
  python-docx,
  python-pptx,
  beautifulsoup4,
  pandas,
  marko,
  openpyxl,
  lxml,
  # ocrmac # not yet packaged
  rapidocr-onnxruntime,
  onnxruntime,
  pillow,
  pyarrow,
  # build system
  poetry-core,
  # optional dependencies
  mkdocs-material,
  mkdocs-jupyter,
  # mkdocs-click # not yet packaged
  mkdocstrings,
  # native check inputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "docling";
  version = "2.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DS4SD";
    repo = "docling";
    tag = "v${version}";
    hash = "sha256-OtUFQRNqyTGT1Z41tHziwM5hqbk+tg/97bxhtPVtmN0=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    pydantic
    docling-core
    docling-ibm-models
    deepsearch-glm
    docling-parse
    filetype
    pypdfium2
    pydantic-settings
    huggingface-hub
    requests
    easyocr
    tesserocr
    certifi
    rtree
    scipy
    typer
    python-docx
    python-pptx
    beautifulsoup4
    pandas
    marko
    openpyxl
    lxml
    # ocrmac # not yet packaged
    rapidocr-onnxruntime
    onnxruntime
    pillow
    pyarrow
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
      mkdocs-material
      mkdocs-jupyter
      # mkdocs-click # not yet packaged
      mkdocstrings
      # griffle-pydantic
    ];
  };

  preCheck = ''
    export HOME="$TEMPDIR"
  '';

  nativeCheckInputs = [
    pytestCheckHook
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
