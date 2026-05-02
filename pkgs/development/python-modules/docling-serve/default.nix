{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  setuptools-scm,
  # python dependencies
  docling,
  docling-jobkit,
  docling-mcp,
  fastapi,
  httpx,
  pydantic-settings,
  python-multipart,
  scalar-fastapi,
  opentelemetry-api,
  opentelemetry-sdk,
  opentelemetry-exporter-otlp,
  opentelemetry-instrumentation-fastapi,
  opentelemetry-exporter-prometheus,
  prometheus-client,
  uvicorn,
  websockets,
  tesserocr,
  typer,
  rapidocr,
  onnxruntime,
  torch,
  torchvision,
  gradio,
  nodejs,
  which,
  withUI ? false,
  withTesserocr ? false,
  withRapidocr ? false,
  withCPU ? false,
}:

buildPythonPackage rec {
  pname = "docling-serve";
  version = "1.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-serve";
    tag = "v${version}";
    hash = "sha256-/UM/P/m4KdtYinYd1+Y8ESLfVURc7jQL8KpV2wR2ISs=";
  };

  build-system = [
    hatchling
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "opentelemetry-api"
    "opentelemetry-sdk"
    "opentelemetry-instrumentation-fastapi"
    "opentelemetry-exporter-prometheus"
  ];

  pythonRemoveDeps = [
    "mlx-vlm" # not yet available on nixpkgs
  ];

  dependencies = [
    docling
    docling-jobkit
    docling-mcp
    fastapi
    httpx
    pydantic-settings
    python-multipart
    scalar-fastapi
    opentelemetry-api
    opentelemetry-sdk
    opentelemetry-exporter-otlp
    opentelemetry-instrumentation-fastapi
    opentelemetry-exporter-prometheus
    prometheus-client
    typer
    uvicorn
    websockets
  ]
  ++ lib.optionals withUI optional-dependencies.ui
  ++ lib.optionals withTesserocr optional-dependencies.tesserocr
  ++ lib.optionals withRapidocr optional-dependencies.rapidocr
  ++ lib.optionals withCPU optional-dependencies.cpu;

  optional-dependencies = {
    ui = [
      gradio
      nodejs
      which
    ];
    tesserocr = [
      tesserocr
    ];
    rapidocr = [
      rapidocr
      onnxruntime
    ];
    cpu = [
      torch
      torchvision
    ];
  };

  pythonImportsCheck = [
    "docling_serve"
  ];

  # Require network
  doCheck = false;

  meta = {
    changelog = "https://github.com/docling-project/docling-serve/blob/${src.tag}/CHANGELOG.md";
    description = "Running Docling as an API service";
    homepage = "https://github.com/docling-project/docling-serve";
    license = lib.licenses.mit;
    mainProgram = "docling-serve";
    maintainers = [ ];
  };
}
