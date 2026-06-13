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
  polyfactory,
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
  version = "2.84.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling";
    tag = "v${version}";
    hash = "sha256-rjRGBZDWqao32AGM4WTFubZ50cNqRWxKAOLojgR7uBk=";
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
    polyfactory
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
    "defusedxml"
    "typer"
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
    # Missing optional ASR/XBRL dependencies or require network/model downloads
    "test_asr_pipeline_conversion"
    "test_asr_pipeline_with_silent_audio"
    "test_has_text_and_determine_status_helpers"
    "test_native_and_mlx_transcribe_language_handling"
    "test_native_init_with_artifacts_path_and_device_logging"
    "test_native_run_success_with_bytesio_builds_document"
    "test_native_run_failure_sets_status"
    "test_e2e_xbrl_conversions"

    # Failing against current groundtruth snapshots
    "test_e2e_valid_csv_conversions"
    "test_e2e_docx_conversions"

    # Network/model-dependent failures in sandboxed nix builds
    "test_get_text_from_rect_rotated"
    "test_e2e_webp_conversions"
    "test_cli_convert"
    "test_code_and_formula_conversion"
    "test_formula_conversion_with_page_range"
    "test_conversion_result_json_roundtrip_string"
    "test_picture_classifier"
    "test_e2e_pdfs_conversions"
    "test_e2e_conversions"
    "test_normal_pages_all_present"
    "test_failed_pages_added_to_document_1page"
    "test_failed_pages_added_to_document_2pages"
    "test_failed_pages_have_size_info"
    "test_errors_recorded_for_failed_pages"
    "test_convert_path"
    "test_convert_stream"
    "test_page_range"
    "test_document_timeout"
    "test_ocr_coverage_threshold"
    "test_parser_backends"
    "test_pipeline_cache_after_initialize"
    "test_confidence"
    "test_get_text_from_rect"
    "test_threaded_pipeline_multiple_documents"
    "test_pipeline_comparison"
    "test_pypdfium_threaded_pipeline"
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
