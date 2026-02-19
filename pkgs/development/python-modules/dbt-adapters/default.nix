{
  lib,
  agate,
  buildPythonPackage,
  dbt-common,
  dbt-protos,
  fetchPypi,
  hatchling,
  mashumaro,
  protobuf,
  pytestCheckHook,
  pytz,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "dbt-adapters";
  version = "1.16.7";
  pyproject = true;

  # missing tags on GitHub
  src = fetchPypi {
    pname = "dbt_adapters";
    inherit version;
    hash = "sha256-I3bE6RP0Udp4bO+OXlRdXM2H+TaXvNFJiHIrqgb0i4A=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "mashumaro"
    "protobuf"
  ];

  dependencies = [
    agate
    dbt-common
    dbt-protos
    mashumaro
    protobuf
    pytz
    typing-extensions
  ]
  ++ mashumaro.optional-dependencies.msgpack;

  pythonImportsCheck = [ "dbt.adapters" ];

  # circular dependencies
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Set of adapter protocols and base functionality that supports integration with dbt-core";
    homepage = "https://github.com/dbt-labs/dbt-adapters";
    changelog = "https://github.com/dbt-labs/dbt-adapters/blob/main/dbt-adapters/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
