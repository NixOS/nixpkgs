{
  lib,
  agate,
  buildPythonPackage,
  dbt-common,
  fetchFromGitHub,
  hatchling,
  mashumaro,
  protobuf,
  pytestCheckHook,
  pythonOlder,
  pytz,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "dbt-adapters";
  version = "1.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-adapters";
    tag = "v${version}";
    hash = "sha256-l2OwGbYFqUF6NOpIxmgyd7B3sCsZTCgu4noaSfwRFps=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "protobuf" ];

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
    changelog = "https://github.com/dbt-labs/dbt-adapters/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
