{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

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
  pycrdt,
  pygments,
  pymdown-extensions,
  pyyaml,
  ruff,
  starlette,
  tomlkit,
  typing-extensions,
  uvicorn,
  websockets,

  # tests
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "marimo";
  version = "0.10.14";
  pyproject = true;

  # The github archive does not include the static assets
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Af8KNgKBhgm2AwCrCrSRYWutarm4Z+ftdt0mFgApcsk=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "pycrdt"
    "websockets"
  ];

  dependencies = [
    click
    docutils
    itsdangerous
    jedi
    markdown
    narwhals
    packaging
    psutil
    pycrdt
    pygments
    pymdown-extensions
    pyyaml
    ruff
    starlette
    tomlkit
    uvicorn
    websockets
  ] ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ];

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
