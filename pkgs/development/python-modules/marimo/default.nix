{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  uv-build,

  # dependencies
  click,
  docutils,
  itsdangerous,
  jedi,
  loro,
  markdown,
  msgspec,
  narwhals,
  packaging,
  psutil,
  pygments,
  pymdown-extensions,
  pyyaml,
  ruff,
  starlette,
  tomlkit,
  uvicorn,
  websockets,

  # tests
  versionCheckHook,
}:
buildPythonPackage rec {
  pname = "marimo";
  version = "0.20.4";
  pyproject = true;

  # The github archive does not include the static assets
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f0bOg3lTcXUEZz4z5H+0KmGb9fnSAA0aOjsWY6R8VJg=";
  };

  build-system = [ uv-build ];

  dependencies = [
    click
    docutils
    itsdangerous
    jedi
    loro
    markdown
    msgspec
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
  ];

  pythonImportsCheck = [ "marimo" ];

  # The pypi archive does not contain tests so we do not use `pytestCheckHook`
  nativeCheckInputs = [
    versionCheckHook
  ];

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
