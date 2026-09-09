{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  certifi,
  docling-core,
  platformdirs,
  pluggy,
  pydantic,
  pydantic-settings,
  python-dateutil,
  python-dotenv,
  requests,
  six,
  tabulate,
  tqdm,
  typer,
  urllib3,
  anyio,
  fastapi,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "deepsearch-toolkit";
  version = "2.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DS4SD";
    repo = "deepsearch-toolkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nrz9pvyA5gPIaKt6CsJOB9cLy3sXiWW5e1Rk4vtNIY8=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    certifi
    docling-core
    platformdirs
    pluggy
    pydantic
    pydantic-settings
    python-dateutil
    python-dotenv
    requests
    six
    tabulate
    tqdm
    typer
    urllib3
  ];

  pythonRelaxDeps = [
    "certifi"
    "urllib3"
  ];

  optional-dependencies = {
    api = [
      anyio
      fastapi
      uvicorn
    ];
  };

  pythonImportsCheck = [ "deepsearch" ];

  # The remaining tests either require the creation of a deepsearch profile, or
  # exercise the deprecated `export_to_markdown`, which relies on the legacy
  # document models docling-core removed in favor of empty import shims:
  # https://github.com/docling-project/docling-core/pull/644
  doCheck = false;

  meta = {
    changelog = "https://github.com/DS4SD/deepsearch-toolkit/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Interact with the Deep Search platform for new knowledge explorations and discoveries";
    homepage = "https://github.com/DS4SD/deepsearch-toolkit";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
