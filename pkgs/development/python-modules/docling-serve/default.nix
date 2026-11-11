{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,

  # build-system
  setuptools,

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
}:

buildPythonPackage (finalAttrs: {
  pname = "docling-serve";
  version = "1.38.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-serve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B71HuMIUQG+tSogW1pPlMtcBtZQ8kkWppKNdZDFwgEM=";
  };

  build-system = [
    setuptools
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
  ++ lib.optionals withTesserocr finalAttrs.passthru.optional-dependencies.tesserocr
  ++ lib.optionals withRapidocr finalAttrs.passthru.optional-dependencies.rapidocr;

  optional-dependencies = {
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

  # Web UI bundle, served when DOCLING_SERVE_ENABLE_UI is set
  nativeBuildInputs = lib.optionals withUI [
    nodejs
    npmHooks.npmConfigHook
  ];
  npmRoot = "ui";
  npmDeps =
    if withUI then
      fetchNpmDeps {
        name = "docling-serve-ui-${finalAttrs.version}-npm-deps";
        src = "${finalAttrs.src}/ui";
        hash = "sha256-lEKhwvkVMGuMVjk87/u19ridN/dQnFRh+I9G6s4eMBQ=";
      }
    else
      null;
  preBuild = lib.optionalString withUI ''
    npm --prefix ui run build
  '';

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
