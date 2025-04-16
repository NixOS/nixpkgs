{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  setuptools-scm,
  # python dependencies
  docling,
  fastapi,
  httpx,
  pydantic-settings,
  python-multipart,
  uvicorn,
  websockets,
  gradio,
  nodejs,
  which,
  withUI ? false,
}:

buildPythonPackage rec {
  pname = "docling-serve";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-serve";
    tag = "v${version}";
    hash = "sha256-QasHVoJITOuys4hASwC43eIy5854G12Yvu7Zncr9ia8=";
  };

  build-system = [
    hatchling
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "websockets"
  ];

  dependencies = [
    docling
    fastapi
    httpx
    pydantic-settings
    python-multipart
    uvicorn
    websockets
  ] ++ lib.optionals withUI optional-dependencies.ui;

  optional-dependencies = {
    ui = [
      gradio
      nodejs
      which
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
    maintainers = with lib.maintainers; [ drupol ];
  };
}
