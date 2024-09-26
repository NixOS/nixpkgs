{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  agate,
  dbt-common,
  mashumaro,
  protobuf,
  pytz,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dbt-adapters";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-adapters";
    rev = "refs/tags/v${version}";
    hash = "sha256-i5sGgkFrW/37PH5XnH2bf/bTNgCZwEgNZT9IMbOJwLQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    agate
    dbt-common
    mashumaro
    protobuf
    pytz
    typing-extensions
  ] ++ mashumaro.optional-dependencies.msgpack;

  pythonImportsCheck = [ "dbt.adapters" ];

  # circular dependencies
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "The set of adapter protocols and base functionality that supports integration with dbt-core";
    homepage = "https://github.com/dbt-labs/dbt-adapters";
    changelog = "https://github.com/dbt-labs/dbt-adapters/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
