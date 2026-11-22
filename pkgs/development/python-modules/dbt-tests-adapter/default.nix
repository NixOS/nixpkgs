{
  lib,
  agate,
  buildPythonPackage,
  fetchFromGitHub,
  dbt-adapters,
  dbt-common,
  hatchling,
  pyyaml,
  freezegun,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  pytest-dotenv,
  pytest-mock,
  pytest-xdist,
  postgresql,
  postgresqlTestHook,
  git,
}:

buildPythonPackage rec {
  pname = "dbt-tests-adapter";
  version = "1.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-adapters";
    # Check https://pypi.org/project/dbt-tests-adapter/#history for version to revision mapping
    rev = "ccfd06c70900545577795f7730596a7d274b1edc";
    hash = "sha256-Kf+rQgxhdSe0QYcjk3kS+SzNBdTtTWWtCzAVUGU7/pE=";
  };

  sourceRoot = "${src.name}/dbt-tests-adapter";

  build-system = [ hatchling ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  dependencies = [
    dbt-adapters
    dbt-common
    pyyaml
    freezegun
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "dbt.tests.adapter" ];

  meta = {
    description = "Internal test utilities for dbt adapters";
    homepage = "https://github.com/dbt-labs/dbt-adapters/tree/main/dbt-tests-adapter";
    changelog = "https://github.com/dbt-labs/dbt-adapters/blob/main/dbt-tests-adapter/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.fliegendewurst ];
  };
}
