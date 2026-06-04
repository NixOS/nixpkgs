{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pythonOlder,

  hatchling,
  setuptools,

  click,
  dagster-shared,
  github3-py,
  jinja2,
  packaging,
  pyyaml,
  questionary,
  requests,
  typer,
  validators,
}:

buildPythonPackage (finalAttrs: {
  pname = "dagster-cloud-cli";
  version = "1.13.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dagster-io";
    repo = "dagster";
    tag = finalAttrs.version;
    hash = "sha256-I/yve9ztaaV9AXnWkocFplgrhxCm6KI7bd/W9TawQOM=";
  };

  sourceRoot = "${finalAttrs.src.name}/python_modules/libraries/dagster-cloud-cli";

  build-system = [ hatchling ];

  dependencies = [
    click
    dagster-shared
    github3-py
    jinja2
    packaging
    pyyaml
    questionary
    requests
    setuptools
    typer
    validators
  ];

  doCheck = false;

  pythonImportsCheck = [ "dagster_cloud_cli" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Command-line interface for Dagster+ Cloud";
    homepage = "https://github.com/dagster-io/dagster";
    changelog = "https://github.com/dagster-io/dagster/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ silky ];
    mainProgram = "dagster-cloud";
  };
})
