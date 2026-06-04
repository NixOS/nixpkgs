{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  hatchling,

  dagster,
  psycopg2,
}:

buildPythonPackage (finalAttrs: {
  pname = "dagster-postgres";
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

  sourceRoot = "${finalAttrs.src.name}/python_modules/libraries/dagster-postgres";

  build-system = [ hatchling ];

  # Upstream pins `psycopg2-binary`; nixpkgs builds `psycopg2` from source which
  # exposes the same `psycopg2` Python import, so drop the pip-name constraint
  # from the wheel's metadata and depend on `psycopg2` instead.
  pythonRemoveDeps = [ "psycopg2-binary" ];

  dependencies = [
    dagster
    psycopg2
  ];

  doCheck = false;

  pythonImportsCheck = [ "dagster_postgres" ];

  # nix-update-script is omitted: this package uses Dagster's offset library
  # versioning (0.X.Y here vs the monorepo's 1.A.B tag), so both `version` and
  # `src.tag` must move together on each bump. Update manually.

  meta = {
    description = "PostgreSQL storage backend for Dagster";
    homepage = "https://github.com/dagster-io/dagster";
    changelog = "https://github.com/dagster-io/dagster/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ silky ];
  };
})
