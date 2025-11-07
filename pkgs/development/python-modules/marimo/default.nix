{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  uv-build,

  # dependencies
  click,
  docutils,
  itsdangerous,
  jedi,
  loro,
  markdown,
  narwhals,
  packaging,
  psutil,
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
  version = "0.15.2";
  pyproject = true;

  # The github archive does not include the static assets
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cmkz/ZyVYfpz4yOxghsXPF4PhRluwqSXo1CcwvwkXFg=";
  };

  build-system = [ uv-build ];

  dependencies = [
    click
    docutils
    itsdangerous
    jedi
    loro
    markdown
    narwhals
    packaging
    psutil
    pygments
    pymdown-extensions
    pyyaml
    ruff
    starlette
    tomlkit
    uvicorn
    websockets
  ]
  ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  pythonImportsCheck = [ "marimo" ];

  # The pypi archive does not contain tests so we do not use `pytestCheckHook`
  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

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
