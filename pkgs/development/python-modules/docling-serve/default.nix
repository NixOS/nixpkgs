{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  docling-core,
  docling-jobkit,
  docling-mcp,
  docling-slim,
  fastapi,
  httpx,
  opentelemetry-api,
  opentelemetry-exporter-otlp,
  opentelemetry-exporter-prometheus,
  opentelemetry-instrumentation-fastapi,
  opentelemetry-sdk,
  prometheus-client,
  pydantic,
  pydantic-settings,
  python-multipart,
  scalar-fastapi,
  typer,
  uvicorn,
  websockets,

  # optional-dependencies
  # ui:
  gradio,
  # tesserocr:
  tesserocr,
  # easyocr:
  easyocr,
  # rapidocr:
  rapidocr,
  onnxruntime,
  # flash-attn:
  flash-attn,

  # tests
  versionCheckHook,

  withUI ? false,
  withTesserocr ? false,
  withRapidocr ? false,
  withCPU ? false,
}:

buildPythonPackage (finalAttrs: {
  pname = "docling-serve";
  version = "1.29.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-serve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sYpi7vgeUH2xw2Jq8Rgou8SsS8aq+TWgq29gqv/xNnU=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "fastapi"
    "opentelemetry-instrumentation-fastapi"
  ];
  dependencies = [
    docling-core
    docling-jobkit
    docling-mcp
    docling-slim
    fastapi
    httpx
    opentelemetry-api
    opentelemetry-exporter-otlp
    opentelemetry-exporter-prometheus
    opentelemetry-instrumentation-fastapi
    opentelemetry-sdk
    prometheus-client
    pydantic
    pydantic-settings
    python-multipart
    scalar-fastapi
    typer
    uvicorn
    websockets
  ]
  ++ docling-slim.optional-dependencies.standard
  ++ docling-slim.optional-dependencies.service-client
  ++ docling-slim.optional-dependencies.models-remote
  ++ docling-slim.optional-dependencies.format-opendocument
  ++ docling-jobkit.optional-dependencies.rq
  ++ docling-jobkit.optional-dependencies.ray
  ++ docling-jobkit.optional-dependencies.azure
  ++ docling-jobkit.optional-dependencies.gcloudstorage
  ++ docling-jobkit.optional-dependencies.gdrive
  ++ fastapi.optional-dependencies.standard
  ++ uvicorn.optional-dependencies.standard
  ++ lib.optionals withUI finalAttrs.passthru.optional-dependencies.ui
  ++ lib.optionals withTesserocr finalAttrs.passthru.optional-dependencies.tesserocr
  ++ lib.optionals withRapidocr finalAttrs.passthru.optional-dependencies.rapidocr
  ++ lib.optionals withCPU finalAttrs.passthru.optional-dependencies.cpu;

  optional-dependencies = {
    ui = [
      gradio
    ];
    tesserocr = [
      tesserocr
    ];
    easyocr = [
      easyocr
    ];
    rapidocr = [
      rapidocr
      onnxruntime
    ];
    flash-attn = [
      flash-attn
    ];
  };

  pythonImportsCheck = [
    "docling_serve"
  ];

  # Python tests require network
  nativeCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Running Docling as an API service";
    homepage = "https://github.com/docling-project/docling-serve";
    changelog = "https://github.com/docling-project/docling-serve/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "docling-serve";
    maintainers = [ ];
  };
})
