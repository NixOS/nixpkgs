{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  certifi,
  docling-core,
  filetype,
  langcodes,
  pluggy,
  pydantic,
  pydantic-settings,
  requests,
  tqdm,

  # optional-dependencies
  # cli:
  python-dotenv,
  rich,
  typer,
  # convert-core:
  numpy,
  pillow,
  rtree,
  scipy,
  # extract-core:
  polyfactory,
  # feat-ocr-easyocr:
  easyocr,
  scikit-image,
  # feat-ocr-rapidocr-onnx:
  onnxruntime,
  rapidocr,
  # feat-ocr-tesserocr:
  pandas,
  tesserocr,
  # feat-asr-transformers:
  torchaudio,
  # format-audio:
  numba,
  openai-whisper,
  # format-docx:
  python-docx,
  # format-email:
  mail-parser,
  python-oxmsg,
  # format-html:
  beautifulsoup4,
  # format-html-render:
  playwright,
  # format-latex:
  pylatexenc,
  # format-markdown:
  marko,
  # format-opendocument:
  odfdo,
  # format-pdf-docling:
  docling-parse,
  pypdfium2,
  # format-pptx:
  python-pptx,
  # format-video:
  librosa,
  scikit-learn,
  soundfile,
  # format-xlsx:
  openpyxl,
  #  format-xml-jats:
  lxml,
  # format-xml-uspto:
  defusedxml,
  # models-local:
  accelerate,
  docling-ibm-models,
  huggingface-hub,
  torch,
  torchvision,
  # models-remote:
  tritonclient,
  # models-vlm-inline:
  einops,
  open-clip-torch,
  peft,
  timm,
  transformers,
  # service-client:
  httpx,
  websockets,

  # tests
  fastapi,
  ffmpeg-headless,
  gitMinimal,
  matplotlib,
  pytest-xdist,
  pytestCheckHook,
  uvicorn,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "docling-slim";
  version = "2.145.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yjDXSiu6mgXYP2FcYTkNA62BcFr+IXjVDRLqm1Ebad4=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    certifi
    docling-core
    filetype
    langcodes
    pluggy
    pydantic
    pydantic-settings
    requests
    tqdm
  ];

  optional-dependencies = rec {
    cli = [
      python-dotenv
      rich
      typer
    ];
    convert-core = [
      numpy
      pillow
      rtree
      scipy
    ];
    extract-core = convert-core ++ [
      polyfactory
    ];
    feat-asr-transformers = format-audio ++ [
      torchaudio
      transformers
    ];
    # docling-core[chunking], whose extra deps nixpkgs already ships unconditionally
    feat-chunking = [
      docling-core
    ];
    feat-ocr-easyocr = [
      easyocr
      scikit-image
    ];
    # ocrmac is darwin-only and not packaged in nixpkgs
    feat-ocr-mac = [ ];
    # nemotron-ocr is not packaged in nixpkgs
    feat-ocr-nemotron = [ ];
    feat-ocr-rapidocr = [
      rapidocr
    ];
    feat-ocr-rapidocr-onnx = [
      onnxruntime
      rapidocr
    ];
    feat-ocr-tesserocr = [
      pandas
      tesserocr
    ];
    # whisper-s2t-reborn is not packaged in nixpkgs
    format-audio = [
      numba
      openai-whisper
    ];
    format-docx = [
      python-docx
    ];
    format-email = format-html ++ [
      mail-parser
      python-oxmsg
    ];
    format-html = [
      beautifulsoup4
    ];
    format-html-render = [
      playwright
    ];
    format-iwork = [
      defusedxml
    ];
    format-latex = [
      pylatexenc
    ];
    format-markdown = [
      marko
    ];
    format-office = format-docx ++ format-pptx ++ format-xlsx;
    format-opendocument = [
      odfdo
    ];
    format-pdf = format-pdf-pypdfium2 ++ format-pdf-docling;
    format-pdf-docling = [
      docling-parse
      pypdfium2
    ];
    format-pdf-pypdfium2 = [
      pypdfium2
    ];
    format-pptx = [
      pylatexenc
      python-pptx
    ];
    # resemblyzer is not packaged in nixpkgs
    format-video = format-audio ++ [
      librosa
      scikit-learn
      soundfile
    ];
    format-web = format-html ++ format-markdown;
    format-xlsx = [
      openpyxl
    ];
    format-xml-jats = format-html ++ [
      lxml
    ];
    format-xml-uspto = format-html ++ [
      defusedxml
    ];
    # arelle-release is not packaged in nixpkgs
    format-xml-xbrl = [ ];
    models-local = [
      accelerate
      defusedxml
      docling-ibm-models
      huggingface-hub
      torch
      torchvision
    ];
    models-onnxruntime = [
      onnxruntime
      # onnxruntime-gpu
    ];
    models-remote = [
      tritonclient
    ];
    # qwen-vl-utils is not packaged in nixpkgs
    models-vlm-inline = [
      accelerate
      einops
      open-clip-torch
      peft
      timm
      transformers
    ];
    service-client = [
      httpx
      python-dotenv
      rich
      typer
      websockets
    ];

    standard =
      cli
      ++ extract-core
      ++ feat-chunking
      ++ feat-ocr-rapidocr
      ++ format-email
      ++ format-iwork
      ++ format-latex
      ++ format-office
      ++ format-pdf
      ++ format-web
      ++ models-local
      ++ service-client;

    # format-video is deliberately excluded, as upstream does
    all =
      standard
      ++ feat-ocr-easyocr
      ++ feat-ocr-mac
      ++ feat-ocr-tesserocr
      ++ format-audio
      ++ format-html-render
      ++ format-xml-jats
      ++ format-xml-uspto
      ++ format-xml-xbrl
      ++ models-onnxruntime
      ++ models-remote
      ++ models-vlm-inline;
  };

  pythonImportsCheck = [ "docling" ];

  nativeCheckInputs = [
    beautifulsoup4
    docling-ibm-models
    docling-parse
    easyocr
    fastapi
    ffmpeg-headless
    gitMinimal
    mail-parser
    marko
    matplotlib
    openpyxl
    pylatexenc
    pypdfium2
    pytest-xdist
    pytestCheckHook
    python-docx
    python-oxmsg
    python-pptx
    rapidocr
    rtree
    scipy
    uvicorn
    websockets
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Downloads models from HuggingFace or fetches remote documents
    "test_cli_convert"
    "test_cli_html_fetches_remote_images_with_separate_headers"
    "test_confidence"
    "test_convert_path"
    "test_convert_remote_too_large_filesize_limit_wout_exception"
    "test_convert_stream"
    "test_document_timeout"
    "test_e2e_conversions"
    "test_e2e_html_conversion_with_images"
    "test_extraction_with_dict_template"
    "test_extraction_with_pydantic_class_template"
    "test_extraction_with_pydantic_instance_template"
    "test_extraction_with_string_template"
    "test_fetch_remote_images"
    "test_fetch_remote_images_with_custom_headers"
    "test_get_text_from_rect_rotated"
    "test_load_image_data_enforces_size_limit"
    "test_page_error_carries_page_no"
    "test_page_range"
    "test_parser_backends"
    "test_pipeline_cache_after_initialize"
    "test_pipeline_cache_with_chart_extraction"
    "test_pipeline_materializes_format_neutral_fields"
    "test_rapidocr_detect_orientation_reads_rotated_text"
    "test_rotated_page_ocr_text_reaches_default_export"

    # Require openai-whisper, which is too heavy a dependency to pull in just for these
    "test_asr_pipeline_conversion"
    "test_asr_pipeline_with_silent_audio"
    "test_has_text_and_determine_status_helpers"
    "test_native_and_mlx_transcribe_language_handling"
    "test_native_distil_artifacts_path_missing_checkpoint_raises"
    "test_native_init_with_artifacts_path_and_device_logging"
    "test_native_run_failure_sets_status"
    "test_native_run_success_with_bytesio_builds_document"

    # The sandbox pins OMP_NUM_THREADS=1, while the test expects the built-in default of 4
    "test_accelerator_options"

    # Needs LibreOffice on PATH to render DrawingML, and a Pillow with WMF support
    "test_e2e_docx_conversions"

    # AttributeError: <class 'PIL.WmfImagePlugin.WmfStubImageFile'> has no attribute '_handler'
    "test_pptx_emf_picture_survives_without_pillow_metafile_support"

    # Failed: DID NOT RAISE ValueError (localhost resolution differs in the sandbox)
    "test_fetch_refuses_non_public_host"
    "test_fetch_refuses_redirect_to_non_public_host"
  ];

  disabledTestPaths = [
    # Download models from HuggingFace or fetch remote documents
    "tests/test_backend_webp.py"
    "tests/test_code_formula.py"
    "tests/test_conversion_result_json.py"
    "tests/test_document_picture_classifier.py"
    "tests/test_e2e_conversion.py"
    "tests/test_e2e_table_structure_ocr.py"
    "tests/test_failed_pages.py"
    "tests/test_heading_hierarchy_pdf.py"
    "tests/test_kserve_v2_ocr_remote_gate.py"
    "tests/test_layout_picture_table_overlap.py"
    "tests/test_pdf_password.py"
    "tests/test_progress_events_pdf.py"
    "tests/test_threaded_pipeline.py"

    # arelle-release is not packaged in nixpkgs
    "tests/test_backend_xbrl.py"

    # tesserocr is packaged without the tessdata it needs to initialize
    "tests/test_e2e_ocr_conversion.py"

    # Require the tesseract binary or download models from HuggingFace
    "tests/test_replace_broken_text_layer.py"
  ];

  # Many tests spin up fake HTTP services on localhost
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Modular version of the Docling package";
    homepage = "https://github.com/docling-project/docling";
    changelog = "https://github.com/docling-project/docling/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
