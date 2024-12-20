{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  click,
  docutils,
  itsdangerous,
  jedi,
  markdown,
  narwhals,
  packaging,
  psutil,
  pygments,
  pymdown-extensions,
  ruff,
  starlette,
  tomlkit,
  uvicorn,
  websockets,
  pyyaml,

  # tests
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "marimo";
  version = "0.9.27";
  pyproject = true;

  # The github archive does not include the static assets
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vs1miLjM/xRrnFYpHte65CfDt4ZRoCKjFMClWukIWZY=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "websockets" ];

  dependencies = [
    click
    docutils
    itsdangerous
    jedi
    markdown
    narwhals
    packaging
    psutil
    pygments
    pymdown-extensions
    ruff
    starlette
    tomlkit
    uvicorn
    websockets
    pyyaml
  ];

  pythonImportsCheck = [ "marimo" ];

  # The pypi archive does not contain tests so we do not use `pytestCheckHook`
  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Reactive Python notebook that's reproducible, git-friendly, and deployable as scripts or apps";
    homepage = "https://github.com/marimo-team/marimo";
    changelog = "https://github.com/marimo-team/marimo/releases/tag/${version}";
    license = lib.licenses.asl20;
    mainProgram = "marimo";
    maintainers = with lib.maintainers; [
      akshayka
      dmadisetti
    ];
  };
}
