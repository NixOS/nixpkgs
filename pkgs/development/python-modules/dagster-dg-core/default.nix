{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pythonOlder,

  hatchling,
  setuptools,

  click,
  click-aliases,
  dagster-cloud-cli,
  dagster-shared,
  gql,
  jinja2,
  jsonschema,
  markdown,
  packaging,
  python-dotenv,
  pyyaml,
  rich,
  tomlkit,
  typer,
  typing-extensions,
  watchdog,
  yaspin,
}:

buildPythonPackage (finalAttrs: {
  pname = "dagster-dg-core";
  version = "1.13.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dagster-io";
    repo = "dagster";
    tag = finalAttrs.version;
    hash = "sha256-I/yve9ztaaV9AXnWkocFplgrhxCm6KI7bd/W9TawQOM=";
  };

  sourceRoot = "${finalAttrs.src.name}/python_modules/libraries/dagster-dg-core";

  build-system = [ hatchling ];

  # Upstream caps tomlkit<0.13.3 but nixpkgs ships 0.14.x.
  pythonRelaxDeps = [
    "tomlkit"
  ];

  dependencies = [
    click
    click-aliases
    dagster-cloud-cli
    dagster-shared
    gql
    jinja2
    jsonschema
    markdown
    packaging
    python-dotenv
    pyyaml
    rich
    setuptools
    tomlkit
    typer
    typing-extensions
    watchdog
    yaspin
  ];

  doCheck = false;

  pythonImportsCheck = [ "dagster_dg_core" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Core library shared by Dagster developer-tooling CLIs";
    homepage = "https://github.com/dagster-io/dagster";
    changelog = "https://github.com/dagster-io/dagster/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ silky ];
  };
})
