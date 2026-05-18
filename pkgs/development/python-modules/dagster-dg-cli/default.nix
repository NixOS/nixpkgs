{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pythonOlder,

  hatchling,

  dagster,
  dagster-cloud-cli,
  dagster-dg-core,
  dagster-rest-resources,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "dagster-dg-cli";
  version = "1.13.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dagster-io";
    repo = "dagster";
    tag = finalAttrs.version;
    hash = "sha256-I/yve9ztaaV9AXnWkocFplgrhxCm6KI7bd/W9TawQOM=";
  };

  sourceRoot = "${finalAttrs.src.name}/python_modules/libraries/dagster-dg-cli";

  build-system = [ hatchling ];

  dependencies = [
    dagster
    dagster-cloud-cli
    dagster-dg-core
    dagster-rest-resources
    typer
  ];

  doCheck = false;

  pythonImportsCheck = [ "dagster_dg_cli" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Developer-tooling CLI for Dagster projects";
    homepage = "https://github.com/dagster-io/dagster";
    changelog = "https://github.com/dagster-io/dagster/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ silky ];
    mainProgram = "dg";
  };
})
