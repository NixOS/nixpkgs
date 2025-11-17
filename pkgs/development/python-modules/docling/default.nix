{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  poetry-core,

  # dependencies
  accelerate,
  beautifulsoup4,
  certifi,
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
  pluggy,
  pydantic,
  pydantic-settings,
  pylatexenc,
  pypdfium2,
  python-docx,
  python-pptx,
  rapidocr,
  requests,
  rtree,
  scipy,
  tesserocr,
  tqdm,
  transformers,
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
  version = "2.47.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling";
    tag = "v${version}";
    hash = "sha256-U82hGvWXkKwZ4um0VevVoYiIfzswu5hLDYvxtqJqmHU=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    accelerate
    beautifulsoup4
    certifi
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
    pluggy
    pydantic
    pydantic-settings
    pylatexenc
    pypdfium2
    python-docx
    python-pptx
    rapidocr
    requests
    rtree
    scipy
    tesserocr
    tqdm
    transformers
    typer
  ];

  pythonRelaxDeps = [
    "lxml"
    "pypdfium2"
    "pillow"
  ];

  optional-dependencies = {
    ocrmac = [
      # ocrmac # not yet packaged
    ];
    rapidocr = [
      onnxruntime
      rapidocr
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

    # AssertionError
    # assert doc.export_to_markdown() == pair[1], f"Error in case {idx}"
    "test_ordered_lists"

    # AssertionError: export to md
    "test_e2e_html_conversions"

    # AssertionError: assert 'Unordered li...d code block:' == 'Unordered li...d code block:'
    "test_convert_valid"

    # AssertionError: Markdown file mismatch against groundtruth pftaps057006474.md
    "test_patent_groundtruth"

    # huggingface_hub.errors.LocalEntryNotFoundError: An error happened
    "test_cli_convert"
    "test_code_and_formula_conversion"
    "test_picture_classifier"
    "test_convert_path"
    "test_convert_stream"
    "test_compare_legacy_output"
    "test_ocr_coverage_threshold"
    "test_formula_conversion_with_page_range"

    # requires network access
    "test_page_range"
    "test_parser_backends"
    "test_confidence"
    "test_e2e_webp_conversions"
    "test_asr_pipeline_conversion"
    "test_threaded_pipeline"
    "test_pipeline_comparison"

    # AssertionError: pred_itxt==true_itxt
    "test_e2e_valid_csv_conversions"
  ];

  meta = {
    description = "Get your documents ready for gen AI";
    homepage = "https://github.com/DS4SD/docling";
    changelog = "https://github.com/DS4SD/docling/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "docling";
  };
}
