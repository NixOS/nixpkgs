{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pythonOlder,

  hatchling,

  click,
  dagster,
  dagster-graphql,
  starlette,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "dagster-webserver";
  version = "1.13.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dagster-io";
    repo = "dagster";
    tag = finalAttrs.version;
    hash = "sha256-I/yve9ztaaV9AXnWkocFplgrhxCm6KI7bd/W9TawQOM=";
  };

  sourceRoot = "${finalAttrs.src.name}/python_modules/dagster-webserver";

  build-system = [ hatchling ];

  dependencies = [
    click
    dagster
    dagster-graphql
    starlette
    uvicorn
  ];

  doCheck = false;

  pythonImportsCheck = [ "dagster_webserver" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Web UI and HTTP API server for Dagster";
    homepage = "https://github.com/dagster-io/dagster";
    changelog = "https://github.com/dagster-io/dagster/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ silky ];
    mainProgram = "dagster-webserver";
  };
})
