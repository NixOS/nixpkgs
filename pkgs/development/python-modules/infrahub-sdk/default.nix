{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  pydantic,
  pydantic-settings,
  graphql-core,
  httpx,
  ujson,
  dulwich,
  whenever,
  netutils,
  tomli,
  invoke,
  jinja2,
  jsonschema,
  pytest-asyncio,
  pytest-cov,
  pytest-httpx,
  pytest-xdist,
  pytestCheckHook,
  pyyaml,
  rich,
  ruamel-yaml,
  typer,
  ariadne-codegen,
  gitMinimal,
}:
buildPythonPackage (finalAttrs: {
  pname = "infrahub-sdk";
  version = "1.23.1";
  pyproject = true;
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "opsmill";
    repo = "infrahub-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GugwLYVC8wP/Ahcr9wtXqsHFvlUKDTlT7q9N4Ssrlbo=";
  };

  dependencies = [
    pydantic
    pydantic-settings
    graphql-core
    httpx
    ujson
    dulwich
    whenever
    netutils
    tomli
  ];

  build-system = [
    hatchling
    hatch-vcs
  ];

  # Upstream pins whenever<0.10.0; nixpkgs' whenever is 0.10.5.
  pythonRelaxDeps = [ "whenever" ];

  # whenever 0.10 made ZonedDateTime.round()'s `unit` argument positional-only,
  # breaking Timestamp() (used everywhere) on nixpkgs' newer whenever.
  postPatch = ''
    substituteInPlace infrahub_sdk/timestamp.py \
      --replace-fail 'round(unit="microsecond")' 'round("microsecond")'
  '';

  preCheck = ''
    # Rich wraps CLI output at 80 columns and adds ANSI colours in the
    # sandbox; tests assert on single-line, uncoloured strings
    export COLUMNS=250
    export NO_COLOR=1
    export TERM=dumb
  '';

  nativeCheckInputs = [
    invoke
    jinja2
    jsonschema
    pytest-asyncio
    pytest-cov
    pytest-httpx
    pytest-xdist
    pytestCheckHook
    pyyaml
    rich
    ruamel-yaml
    typer
    ariadne-codegen
    gitMinimal
  ];

  disabledTestPaths = [
    # Needs a running Infrahub instance via infrahub-testcontainers (not packaged).
    "tests/integration"
  ];

  pythonImportsCheck = [ "infrahub_sdk" ];
  meta = {
    description = "Python client library and CLI to interact with the API of an Infrahub instance";
    homepage = "https://github.com/opsmill/infrahub-sdk-python";
    changelog = "https://github.com/opsmill/infrahub-sdk-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
