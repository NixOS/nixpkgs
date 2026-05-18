{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  hatchling,

  dagster-shared,
  httpx,
  pydantic,
}:

buildPythonPackage (finalAttrs: {
  pname = "dagster-rest-resources";
  # Tracks the Dagster libraries 0.X versioning (offset from core: 1.13.5 -> 0.29.5).
  version = "0.29.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dagster-io";
    repo = "dagster";
    tag = "1.13.5";
    hash = "sha256-I/yve9ztaaV9AXnWkocFplgrhxCm6KI7bd/W9TawQOM=";
  };

  sourceRoot = "${finalAttrs.src.name}/python_modules/libraries/dagster-rest-resources";

  build-system = [ hatchling ];

  dependencies = [
    dagster-shared
    httpx
    pydantic
  ];

  doCheck = false;

  pythonImportsCheck = [ "dagster_rest_resources" ];

  # nix-update-script is omitted: this package uses Dagster's offset library
  # versioning (0.X.Y here vs the monorepo's 1.A.B tag), so both `version` and
  # `src.tag` must move together on each bump. Update manually.

  meta = {
    description = "REST API resource bindings for Dagster";
    homepage = "https://github.com/dagster-io/dagster";
    changelog = "https://github.com/dagster-io/dagster/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ silky ];
  };
})
