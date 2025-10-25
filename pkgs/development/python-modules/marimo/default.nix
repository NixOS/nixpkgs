{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,
  uv-build,
  versioneer,

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
  typing-extensions,
  uvicorn,
  websockets,

  # tests
  versionCheckHook,
}:

let
  msgspec-m = msgspec.overridePythonAttrs (old: {
    version = "0.19.2";
    src = fetchFromGitHub {
      owner = "marimo-team";
      repo = "msgspec";
      rev = "0.19.2";
      hash = "sha256-rZv/6xZsE6NNbQnTXq5HKsAHm3yHpzlrgNOP2v8s0KI=";
    };
    build-system = [ setuptools versioneer ];
  });
in
buildPythonPackage rec {
  pname = "marimo";
  version = "0.17.0";
  pyproject = true;

  # The github archive does not include the static assets
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9jThrtwfTXhKHMkukWpHS3PK0C/UtyqrUCI3vPEEQ0o=";
  };

  build-system = [ uv-build ];

  dependencies = [
    click
    docutils
    itsdangerous
    jedi
    loro
    markdown
    msgspec-m
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
