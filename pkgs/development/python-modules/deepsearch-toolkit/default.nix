{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
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
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "deepsearch-toolkit";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DS4SD";
    repo = "deepsearch-toolkit";
    rev = "refs/tags/v${version}";
    hash = "sha256-7XiI/VtXX4lRMreqUh6hJvdIULGvsCEdrd+zV5Jrne0=";
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
    "urllib3"
  ];

  optional-dependencies = rec {
    all = api;
    api = [
      anyio
      fastapi
      uvicorn
    ];
  };

  pythonImportsCheck = [
    "deepsearch"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require the creation of a deepsearch profile
    "test_project_listing"
    "test_system_info"
  ];

  meta = {
    changelog = "https://github.com/DS4SD/deepsearch-toolkit/blob/${src.rev}/CHANGELOG.md";
    description = "Interact with the Deep Search platform for new knowledge explorations and discoveries";
    homepage = "https://github.com/DS4SD/deepsearch-toolkit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
